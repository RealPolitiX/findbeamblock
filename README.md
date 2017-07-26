# findbeamblock
The algorithm identifies the profile of the beam block, a low-intensity nonconvex-shaped object in an diffraction pattern/image, and outputs a mask with the region of the beam block set to 1. A follow-up routine calculates the radial background using the mask.


### Outline of algorithm (steps with * are optional)
A detailed example can be found in the example folder. After loading a diffraction image, follow the sequence below to obtain a filled binarized mask of the beam block
low-intensity 
1. Apply median filter to diffraction image to remove salt-and-pepper noise.
pattern/image.ind coarse edge using [`findPersistentEdge`](https://github.com/RealPolitiX/findbeamblock/blob/master/findPersistentEdge.m).
3. *Improve the coarse edge-finding result by [`radialFilter`](https://github.com/RealPolitiX/findbeamblock/blob/master/radialFilter.m) and [`boundaryFilter`](https://github.com/RealPolitiX/findbeamblock/blob/master/boundaryFilter.m).
4. Use structuring elements to dilate edges.
5. Fill the (semi-)enclosed area in the image using [`rotationFill`](https://github.com/RealPolitiX/findbeamblock/blob/master/rotationFill.m).
6. Use structuring elements to erode away spurious points nearby the edge.
7. *Apply median filter to remove any remaining isolated spots that still exist on the mask.

To find only the edge of the beam block, one can apply any edge-finder again to the binarized mask. Follow up on the beam-block-finding, one can calculate the radial quantile to extract an approximate background of the diffraction image.

8. Calculate the radial background of the diffraction image using [`calculateRadialBackground`](https://github.com/RealPolitiX/findbeamblock/blob/master/calculateRadialBackground.m).


### Dependencies of the radial background removal routine
removeRadialBackground
+---maskBeamBlock
|	+---findPersistentEdge
|	+---radialFilter
|	+---boundaryFilter
|	+---rotationFill
|
+---calculateRadialBackground
	\---quantileNaN


+--- the routine constitutes a separate .m file
\--- the subroutine lives within the parent routine
