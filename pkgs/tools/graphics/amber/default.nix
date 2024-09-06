{ lib, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, cctools
, makeWrapper
, mesa
, python3
, runCommand
, vulkan-headers
, vulkan-loader
, vulkan-validation-layers
}:
let
  # From https://github.com/google/amber/blob/main/DEPS
  glslang = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "glslang";
    rev = "e8dd0b6903b34f1879520b444634c75ea2deedf5";
    hash = "sha256-B6jVCeoFjd2H6+7tIses+Kj8DgHS6E2dkVzQAIzDHEc=";
  };

  lodepng = fetchFromGitHub {
    owner = "lvandeve";
    repo = "lodepng";
    rev = "5601b8272a6850b7c5d693dd0c0e16da50be8d8d";
    hash = "sha256-dD8QoyOoGov6VENFNTXWRmen4nYYleoZ8+4TpICNSpo=";
  };

  shaderc = fetchFromGitHub {
    owner = "google";
    repo = "shaderc";
    rev = "f59f0d11b80fd622383199c867137ededf89d43b";
    hash = "sha256-kHz8Io5GZDWv1FjPyBWRpnKhGygKhSU4L9zl/AKXZlU=";
  };

  spirv-headers = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-Headers";
    rev = "5e3ad389ee56fca27c9705d093ae5387ce404df4";
    hash = "sha256-gjF5mVTXqU/GZzr2S6oKGChgvqqHcQSrEq/ePP2yJys=";
  };

  spirv-tools = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-Tools";
    rev = "9241a58a8028c49510bc174b6c970e3c2b4b8e51";
    hash = "sha256-0qHUpwNDJI2jV4h68QaTNPIwTPxwTt0iAUnMXqFCiJE=";
  };

in
stdenv.mkDerivation (finalAttrs: {
  pname = "amber";
  version = "unstable-2024-08-21";

  src = fetchFromGitHub {
    owner = "google";
    repo = "amber";
    rev = "66399a35927606a435bf7a59756e87e6cb5a0013";
    hash = "sha256-PCO64zI/vzp4HyGz5WpeYpCBeaWjTvz1punWsTz1yiM=";
  };

  buildInputs = [
    vulkan-headers
    vulkan-loader
  ];

  nativeBuildInputs = [
    cmake
    makeWrapper
    pkg-config
    python3
  ] ++ lib.optionals stdenv.isDarwin [
    cctools
  ];

  # Tests are disabled so we do not have to pull in googletest and more dependencies
  cmakeFlags = [ "-DAMBER_SKIP_TESTS=ON" "-DAMBER_DISABLE_WERROR=ON" ];

  prePatch = ''
    cp -r ${glslang}/ third_party/glslang
    cp -r ${lodepng}/ third_party/lodepng
    cp -r ${shaderc}/ third_party/shaderc
    cp -r ${spirv-tools}/ third_party/spirv-tools
    cp -r ${spirv-headers}/ third_party/spirv-headers
    chmod u+w -R third_party

    substituteInPlace tools/update_build_version.py \
      --replace "not os.path.exists(directory)" "True"
  '';

  installPhase = ''
    install -Dm755 -t $out/bin amber image_diff
    wrapProgram $out/bin/amber \
      --suffix VK_LAYER_PATH : ${vulkan-validation-layers}/share/vulkan/explicit_layer.d
  '';

  passthru.tests.lavapipe = runCommand "vulkan-cts-tests-lavapipe" {
    nativeBuildInputs = [ finalAttrs.finalPackage mesa.llvmpipeHook ];
  } ''
    cat > test.amber <<EOF
    #!amber
    # Simple amber compute shader.

    SHADER compute kComputeShader GLSL
    #version 450

    layout(binding = 3) buffer block {
      uvec2 values[];
    };

    void main() {
      values[gl_WorkGroupID.x + gl_WorkGroupID.y * gl_NumWorkGroups.x] =
                    gl_WorkGroupID.xy;
    }
    END  # shader

    BUFFER kComputeBuffer DATA_TYPE vec2<int32> SIZE 524288 FILL 0

    PIPELINE compute kComputePipeline
      ATTACH kComputeShader
      BIND BUFFER kComputeBuffer AS storage DESCRIPTOR_SET 0 BINDING 3
    END  # pipeline

    RUN kComputePipeline 256 256 1

    # Four corners
    EXPECT kComputeBuffer IDX 0 EQ 0 0
    EXPECT kComputeBuffer IDX 2040 EQ 255 0
    EXPECT kComputeBuffer IDX 522240 EQ 0 255
    EXPECT kComputeBuffer IDX 524280 EQ 255 255

    # Center
    EXPECT kComputeBuffer IDX 263168 EQ 128 128
    EOF

    amber test.amber
    touch $out
  '';

  meta = with lib; {
    description = "Multi-API shader test framework";
    homepage = "https://github.com/google/amber";
    license = licenses.asl20;
    maintainers = with maintainers; [ Flakebi ];
  };
})
