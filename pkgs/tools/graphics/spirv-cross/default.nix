{ lib, stdenv, fetchFromGitHub, cmake, python3 }:

stdenv.mkDerivation (finalAttrs: {
  pname = "spirv-cross";
  version = "1.3.250.0";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-Cross";
    rev = "sdk-${finalAttrs.version}";
    hash = "sha256-H4UkR/EiBWpdhdPHNBrdRkl4eN8kD9gEOzpnwfFSdpI=";
  };

  nativeBuildInputs = [ cmake python3 ];

  meta = with lib; {
    description = "A tool designed for parsing and converting SPIR-V to other shader languages";
    homepage = "https://github.com/KhronosGroup/SPIRV-Cross";
    changelog = "https://github.com/KhronosGroup/SPIRV-Cross/releases/tag/${version}";
    platforms = platforms.all;
    license = licenses.asl20;
    maintainers = with maintainers; [ Flakebi ];
  };
})
