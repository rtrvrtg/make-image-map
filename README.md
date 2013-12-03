make-image-map
==============

Command-line scripts for chopping up images into map tiles.

by Geoffrey Roberts

What the script does
====================

This script takes a large image and chops it up into tiles that can be used within a map library such as [Leaflet][leaflet]. Along the way, it will scale the image up so that its widest axis is rounded up to the next highest power of 2. This allows scalable tiles to be generated consistently.

Any transparent areas of the image will be converted to white. All output tiles are in JPEG format.

[leaflet]: http://leafletjs.com

Requires
========

 * [ImageMagick][im]
 * [GDAL][gdal]

[im]: http://www.imagemagick.org/script/index.php
[gdal]: http://www.gdal.org/

Usage
=====

```
chmod u+x make-image-map.sh
./make-image-map.sh (name of input image) (name of output folder)
```

TODO
====

 * Render in other formats
 * Modified transparency handling
 * Cropping
 * Anything else? Feel free to make some suggestions.
