module Jekyll
  module ParagraphSplit
    def paragraph_split(markdown, n)
      blocks = []
      current_block = []
      in_code_block = false

      # Split the markdown into blocks
      markdown.each_line do |line|
        line.chomp!
        if line.start_with?('```')
          if in_code_block
            current_block << line
            blocks << current_block.join("\n")
            current_block = []
            in_code_block = false
          else
            if current_block.any?
              blocks << current_block.join("\n")
              current_block = []
            end
            current_block << line
            in_code_block = true
          end
        elsif in_code_block
          current_block << line
        else
          if line.strip.empty?
            if current_block.any?
              blocks << current_block.join("\n")
              current_block = []
            end
          elsif line.match(/^(\* |\- |\d+\. )/)
            if current_block.any?
              blocks << current_block.join("\n")
              current_block = []
            end
            blocks << line
          elsif line.start_with?(/#+/)
            if current_block.any?
              blocks << current_block.join("\n")
              current_block = []
            end
            blocks << line
          elsif line.strip == '---'
            if current_block.any?
              blocks << current_block.join("\n")
              current_block = []
            end
            blocks << line
          else
            current_block << line
          end
        end
      end

      if current_block.any?
        blocks << current_block.join("\n")
      end

      # Check for horizontal rules
      hr_indices = blocks.each_index.select { |i| blocks[i].strip == '---' }
      hr_count = hr_indices.size

      # Case 1: Exactly n-1 horizontal rules
      if hr_count == n - 1
        groups = []
        previous = 0
        hr_indices.each do |i|
          groups << blocks[previous...i]
          previous = i + 1
        end
        groups << blocks[previous..-1]

        columns = groups.map { |g| g.join("\n\n") }
        columns.fill('', columns.size...n) if columns.size < n
        columns[0...n]
      else
        # Case 2 and 3: Handle other scenarios
        if hr_count > 0 && hr_count < n - 1
          # Split into groups at horizontal rules
          groups = []
          previous = 0
          hr_indices.each do |i|
            groups << blocks[previous...i]
            previous = i + 1
          end
          groups << blocks[previous..-1]

          k = groups.size
          base_cols = n / k
          remainder = n % k
          columns = []

          groups.each_with_index do |group, idx|
            cols_for_group = idx < remainder ? base_cols + 1 : base_cols

            group_columns = Array.new(cols_for_group) { [] }
            total_group_blocks = group.size

            cols_for_group.times do |j|
              start_idx = (j * total_group_blocks) / cols_for_group
              end_idx = ((j + 1) * total_group_blocks) / cols_for_group - 1
              end_idx = [end_idx, total_group_blocks - 1].min

              if start_idx <= end_idx
                group_columns[j] = group[start_idx..end_idx]
              else
                group_columns[j] = []
              end
            end

            columns += group_columns.map { |c| c.join("\n\n") }
          end

          columns
        else
          # Original block distribution
          columns = Array.new(n) { [] }
          total_blocks = blocks.size

          n.times do |i|
            start_idx = (i * total_blocks) / n
            end_idx = ((i + 1) * total_blocks) / n - 1
            end_idx = [end_idx, total_blocks - 1].min

            if start_idx <= end_idx
              columns[i] = blocks[start_idx..end_idx]
            else
              columns[i] = []
            end
          end

          columns.map { |col| col.join("\n\n") }
        end
      end
    end
  end
end

Liquid::Template.register_filter(Jekyll::ParagraphSplit)

