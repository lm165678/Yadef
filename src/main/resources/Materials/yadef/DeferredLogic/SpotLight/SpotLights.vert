uniform mat4 g_WorldViewProjectionMatrix;

out vec4 lightColorInnerAngle;
out vec4 lightPositionOuterAngle;
out vec4 lightDirectionRange;

uniform int m_lightCount;
uniform vec4[MAX_LIGHTS] m_spotLightPositionAngle;
uniform vec4[MAX_LIGHTS] m_spotLightDirectionRange;
uniform vec4[MAX_LIGHTS] m_spotLightColorInnerAngle;

const float offsetMod[5]=float[5](0,1,1,1,1);
const vec3 upMod[5]=vec3[5](    vec3(0),vec3(1),vec3(1),vec3(-1),vec3(-1));
const vec3 leftMod[5]=vec3[5](  vec3(0),vec3(1),vec3(-1),vec3(-1),vec3(1));
const int id[18]=int[18](0, 1, 2, 0, 2, 3, 0, 3, 4, 0, 4, 1,1, 3, 2, 4, 3, 1);

void main(){
    int vertexId=id[int(mod(gl_VertexID,18))];
    int lightId=int(gl_VertexID/18);

    lightColorInnerAngle=m_spotLightColorInnerAngle[lightId];
    lightPositionOuterAngle=m_spotLightPositionAngle[lightId];
    lightDirectionRange=m_spotLightDirectionRange[lightId];
 //   if(lightId>=m_lightCount){
 //       gl_Position=vec4(-2,-2,-2,-2);
 //   }else{
    vec3 left=normalize(cross(lightDirectionRange.xyz,vec3(0,1,0)));
    vec3 up=cross(left,lightDirectionRange.xyz);

    vec3 mod=(left*leftMod[vertexId])+(up*upMod[vertexId]);
    vec3 origin=lightPositionOuterAngle.xyz;
    vec3 centerPoint=origin+offsetMod[vertexId]*lightDirectionRange.xyz*lightDirectionRange.a;
    float range=lightDirectionRange.a;
    float sine=sin(lightPositionOuterAngle.a);
    gl_Position=g_WorldViewProjectionMatrix*vec4(centerPoint+mod*sine*range,1);
 //   }
}