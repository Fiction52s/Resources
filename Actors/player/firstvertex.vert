void main(void)
{

	 // transform the vertex position
    gl_Position = ftransform();

    // transform the texture coordinates
    gl_TexCoord[0] = gl_TextureMatrix[0] * gl_MultiTexCoord0;

    // forward the vertex color
    gl_FrontColor = gl_Color;
	
	
}  