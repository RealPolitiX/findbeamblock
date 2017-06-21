# findbeamblock
Nonconvex shape-finding in analysis of diffraction data

### Outline of algorithm (steps with * are optional)
A detailed example can be found in the example folder
1. Load diffraction image
2. Apply median filter to the diffraction image
3. Find coarse edge using (['findPersistentEdge'](https://github.com/RealPolitiX/findbeamblock/blob/master/findPersistentEdge.m))
4. Use structuring element to dilate edges
5. Fill the (semi-)enclosed area in the image using (['rotationFill']())
6.
