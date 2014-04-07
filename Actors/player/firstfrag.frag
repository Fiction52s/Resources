uniform sampler2D texture;
uniform vec2 testPoint;

void main ()  
{     
   // lookup the pixel in the texture
    vec4 pixel = texture2D(texture, gl_TexCoord[0].xy);
	float dist = 100;
	//float dist = abs( distance( testPoint, gl_FragCoord.xy ) );
	float factor = 50;
	if( (gl_Color * pixel).w > 0 )
	{
		gl_FragColor = vec4( 1, 0, 0, 1 );
	}
	//else if( dist < 200 )
	//{
	//	gl_FragColor = gl_Color * pixel + vec4( 1 / dist * factor , 0.0, 0.0, .5 );  
	//	//gl_FragColor = gl_Color * pixel * vec4( 1, 1, 1, 0 );
	//}
	else
	{
		//gl_FragColor = vec4( 1, 0, 0, .5 );
		gl_FragColor = gl_Color * pixel;
	}
	//gl_FragColor = gl_Color * pixel;
	//gl_FragColor = gl_Color * pixel;
}  