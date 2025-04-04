---
layout: section_two
section-id: "second"
header:
    title: Section Two
    body: |
        This is the second section. You can add more content here as needed.
cta:
    link: "#third"
    text: "Continue to next section"
images:
    - url: /assets/images/IMG_0001_cropped.jpg
      alt: Mountain image
      link: "#first"
      caption: A caption for the first image.
    - url: /assets/images/IMG_0002_cropped.jpg
      alt: Ocean image
      link: "#second"
      caption: A caption for the second image.
    - url: /assets/images/IMG_0003_cropped.jpg
      alt: Beach image
      link: "#third"
      caption: A caption for the third image.
    - url: /assets/images/IMG_0004_cropped.jpg
      alt: Meadows image
      link: "#fourth"
      caption: A caption for the fourth image.
    - url: /assets/images/IMG_0005_cropped.jpg
      alt: River image
      link: "#documentation"
      caption: A caption for the fifth image.
    - url: /assets/images/IMG_0006_cropped.jpg
      alt: River and farm land image
      link: "#documentation"
      caption: A caption for the sixth image.
---

Second section is here. It can contain multiple paragraphs, lists, images, or
other content as you see fit.

Add images to the front matter via the `images` key which is a list of
dictionaries containing `link`, `url`, `alt`, and `caption` keys. For example:

```yaml
---
images:
    - url: /assets/images/IMG_0001.jpg
      alt: Mountain image
      link: "#first"
      caption: A caption for the first image.
    - url: /assets/images/IMG_0002.jpg
      alt: Ocean image
      link: "#second"
      caption: A caption for the second image.
    - url: /assets/images/IMG_0003.jpg
      alt: Beach image
      link: "#third"
      caption: A caption for the third image.
    - url: /assets/images/IMG_0004.jpg
      alt: Meadows image
      link: "#fourth"
      caption: A caption for the fourth image.
---
```

The images will be displayed in a grid. The sizes and aspect ratios will remain
unchanged when display. For the best looking grid, it is recommended to keep all
images the same size and aspect ratio.

