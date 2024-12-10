{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  cctools,
  makeWrapper,
  python3,
  vulkan-headers,
  vulkan-loader,
  vulkan-validation-layers,
}:
let
  glslang = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "glslang";
    rev = "81cc10a498b25a90147cccd6e8939493c1e9e20e";
    hash = "sha256-jTOxZ1nU7kvtdWjPzyIp/5ZeKw3JtYyqhlFeIE7CyX8=";
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
    rev = "e72186b66bb90ed06aaf15cbdc9a053581a0616b";
    hash = "sha256-hd1IGsWksgAfB8Mq5yZOzSyNGxXsCJxb350pD/Gcskk=";
  };

  spirv-headers = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-Headers";
    rev = "d13b52222c39a7e9a401b44646f0ca3a640fbd47";
    hash = "sha256-bjiWGSmpEbydXtCLP8fRZfPBvdCzBoJxKXTx3BroQbg=";
  };

  spirv-tools = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-Tools";
    rev = "d87f61605b3647fbceae9aaa922fce0031afdc63";
    hash = "sha256-lB2i6wjehIFDOQdIPUvCy3zzcnJSsR5vNawPhGmb0es=";
  };

in
stdenv.mkDerivation rec {
  pname = "amber";
  version = "unstable-2023-09-02";

  src = fetchFromGitHub {
    owner = "google";
    repo = pname;
    rev = "8e90b2d2f532bcd4a80069e3f37a9698209a21bc";
    hash = "sha256-LuNCND/NXoNbbTWv7RYQUkq2QXL1qXR27uHwFIz0DXg=";
  };

  buildInputs = [
    vulkan-headers
    vulkan-loader
  ];

  nativeBuildInputs =
    [
      cmake
      makeWrapper
      pkg-config
      python3
    ]
    ++ lib.optionals stdenv.isDarwin [
      cctools
    ];

  # Tests are disabled so we do not have to pull in googletest and more dependencies
  cmakeFlags = [
    "-DAMBER_SKIP_TESTS=ON"
    "-DAMBER_DISABLE_WERROR=ON"
  ];

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

  meta = with lib; {
    description = "Multi-API shader test framework";
    homepage = "https://github.com/google/amber";
    license = licenses.asl20;
    maintainers = with maintainers; [ Flakebi ];
  };
}
