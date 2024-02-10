{ lib, stdenv, fetchFromGitHub, cmake, python3 }:

stdenv.mkDerivation (finalAttrs: {
  pname = "spirv-cross";
  version = "1.3.275.0";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-Cross";
    rev = "vulkan-sdk-${finalAttrs.version}";
    hash = "sha256-Mhr3Yxm5MeLLQFmxWmtXLsq+ZcOE+KMs+3iiTYF8t30=";
  };

  nativeBuildInputs = [ cmake python3 ];

  postFixup = ''
    substituteInPlace $out/lib/pkgconfig/*.pc \
      --replace '=''${prefix}//' '=/'
  '';

  meta = with lib; {
    description = "A tool designed for parsing and converting SPIR-V to other shader languages";
    homepage = "https://github.com/KhronosGroup/SPIRV-Cross";
    changelog = "https://github.com/KhronosGroup/SPIRV-Cross/releases/tag/${version}";
    platforms = platforms.all;
    license = licenses.asl20;
    maintainers = with maintainers; [ Flakebi ];
    mainProgram = "spirv-cross";
  };
})
