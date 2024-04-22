return shader_pixel_create_base64("
    eJxlkLFKA0EURc/bJDiFsD8guGCjTSARi9iISWMRQY2BdBKTFQOJGybRevyDfIDF
    2roWAX9pv8ORmd1FwW7Ove/eeTMSWPttT+ndnnf3gC9AAmtrgGMEPoERUEMcMnU6
    sPaaGwkwpbYBgiLGW6npKx2/zJLnFVlWZ9e3SOUNxovlPNZk/711Mo/1+GkSk2XV
    7ZW3XN217+65nE10skoe1tHhzVF00R/0o8HjeBrrqJcslrN5rKNOs91pdk7azeNW
    q8U1NIQwLVrMWVnHfrG2gdq2PG9QYVqdRYVp1z83NJBvReWepWRUngbe33H8KuTm
    wGc9mz+e+6r3EdQrFkiFYdrwfcrA0M2YX/4wgjVVRrC+3+UKTZXaMC26CFB+L2Mt
    /ABfd1c3
")

/*
    struct PS_INPUT {
        float2 texcoord: TEXCOORD0;
        float4 color: COLOR0;
    };

    struct PS_OUTPUT {
        float4 color: COLOR0;
    };

    SamplerState rSampler: register(s0);
    SamplerState rPrevious;

    float tolerance;

    PS_OUTPUT main(PS_INPUT input) {
        PS_OUTPUT output;

        float3 current = tex2D(rSampler, input.texcoord).rgb;
        float3 reference = tex2D(rPrevious, input.texcoord).rgb;

        float3 tol3 = float3(tolerance,tolerance,tolerance);

        if (all(abs(current-reference) < tol3)) output.color = float4(0,0,0,0);
        else output.color = float4(current,1);

        return output;
    }
*/
