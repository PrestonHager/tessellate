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
    - url: /assets/images/IMG_0001.jpg
      alt: Mountain image
      link: /project/documentation/#second
      caption: A caption for the first image.
    - url: /assets/images/IMG_0002.jpg
      alt: Ocean image
      link: /project/documentation/#second
      caption: A caption for the second image.
---

Second section is here. It can contain multiple paragraphs, lists, images, or
other content as you see fit.

Add images to the front matter via the `images` key which is a list of
dictionaries containing `link`, `url`, `alt`, and `caption` keys. For example:

```yaml
images:
    - url: /assets/images/IMG_0001.jpg
      alt: Mountain image
      link: /project/documentation/#second
      caption: A caption for the first image.
    - url: /assets/images/IMG_0002.jpg
      alt: Ocean image
      link: /project/documentation/#second
      caption: A caption for the second image.
```

