{ lib
, stdenv
, fetchFromGitHub
, cmake
, python3
, vulkanVersions
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "spirv-cross";
  version = vulkanVersions.spirvVersion or vulkanVersions.sdkVersion;

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-Cross";
    rev = vulkanVersions.spirvRev or vulkanVersions.sdkRev;
    hash = vulkanVersions.spirvCrossHash;
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
