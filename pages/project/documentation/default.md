---
layout: default
style: style2
header:
    title: '"Default" Layout'
---

If you want to create a custom layout, it is recommended to use the `default`
layout as a base. Use HTML elements directly in your markdown file. You can then
include it as any other subview with the `subview` liquid tag.

```liquid
{% raw %}
{% subview custom_layout.md %}
{% endraw %}
```

Use the `style` attribute to assign a specific CSS class/style to the view. For
example, the default theme comes with `style1`, `style2`, and `style3` classes.

```yaml
---
layout: default
style: style2
---
```

