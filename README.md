# Creating an issue

**1. Fill in data file**

Data file is `_data/issue.yml`.

This file and article/lesson markdown files make use of author and illustrator "keys". These are permalink-like identifiers for authors and illustrators, in the form of `firstname-lastname`. (e.g. "Simon Collison" becomes `simon-collison`, and "Superbrothers" becomes `superbrothers`)

Besides a Table of Contents `toc`, there are lists of authors `loa` and lists of illustrators. These are merely alphabetical sortings (by last name) to be used in the Authors and Illustrators pages.

**2. Add content**

All files are under `EPUB/html/content`:

- All articles and lesson files are required, and need correct author keys in the YAML front-end matter.
- Letter From the Publisher is optional.
- Acknowledgements are optional. 

**3. Add images**

1. Illustrations go in `EPUB/images/illustrations/[illustrator-key].jpg`
2. Portraits go in `EPUB/images/portraits/[author-key].jpg`
3. Cover goes in `EPUB/images/cover.jpg`

Note: All files are JPG.