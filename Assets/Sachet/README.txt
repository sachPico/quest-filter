This is a custom camera filter for Unity. No post-processing is required.

<<< PROCEDURE >>>
Included in the prefab is three objects:
	- Filter Display:
		To display a filtered view from the filter camera
	- Filter Camera:
		The camera's view is rendered to a target texture
	- Thermal Filter Lens:
		Turn this on only when thermal vision is required

A.>>> Basic Setup
Make sure the following requirements are fulfilled:

	---Filter Camera---
	1. Make sure the "Filter Camera" doesn't render "Filter Display" object. You can set it by unchecking the "Filter 		Display"'s layer in the "Culling Mask" setting of the camera's "Rendering".
	2. Change the background type to "Solid Color", then pick any gray color you want. Note that whatever gray color you pick will affect the resulting color in thermal vision filter.
	3. Make sure the "Output Texture" has a Render Texture.

	---Filter Display---
	1. Separate "Filter Display" to its own layer.
	2. Set the shader for "Filter Display"'s material to "Sachet/Filter/[Any filter you want]".
	3. Set the "Render Texture" as the "Base Map" of the filter's material.	

	---ThermalFilterLens---
	1. Set the shader for "ThermalFilterLens"'s material to "Sachet/Mask".

The shader for all object's material must be using "StencilLit" shader for stencil masking to properly work when using thermal vision filter. All object's material must have additional material containing an ambient temperature texture, therefore one object will have two different materials.

	Material: 2
		Element 0:	[A material using "StencilLit" shader]
		Element 1:	[A material using "StencilThermal" shader]

B.>>> Thermal Vision
To use a thermal vision, make sure all objects acquired the aforementioned ambient temperature texture. You can make it from baking an AO map from external 3D modelling software. The "Thermal Filter Lens" must also be turned on. Any portion of a mesh that is inside the stencil mask will be rendered using the ambient temperature texture as the main texture and using unlit shader, so ensure your "ThermalFilterLens" has completely covered the "FilterCamera"'s view range. Also, make sure the "ThermalFilterLens"' forward local position is greater than the "FilterCamera"'s near clip distance.

The thermal vision filter's color gradient is currently acquired from a formula since Unity's ShaderLab doesn't support gradient input parameter.

C.>>> Night Vision
Night vision only use what the "Filter Camera" sees and retrieve the luminance value in each pixels. There are several properties that you should pay attention in the "NightVisionFilter" shader.

	- Luminance Multiplier (Range 0-1)
	Control the luminance intensity.

	- Step Bias
	Control the max parameter for DirectX's smoothStep function. The higher the value, the darker the resulting image. 	Basic knowledge of smooth-step function is suggested.

	- Noise Adder
	Add the white noise value. The higher the value, the less white noise is visible on the display.