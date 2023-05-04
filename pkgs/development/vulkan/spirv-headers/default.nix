{ lib
, stdenv
, fetchFromGitHub
, cmake
, vulkanVersions
}:

stdenv.mkDerivation rec {
  pname = "spirv-headers";
  version = vulkanVersions.spirvVersion or vulkanVersions.sdkVersion;

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-Headers";
    rev = vulkanVersions.spirvRev or vulkanVersions.sdkRev;
    hash = vulkanVersions.spirvHeadersHash;
  };

  nativeBuildInputs = [ cmake ];

  # https://github.com/KhronosGroup/SPIRV-Headers/issues/282
  postPatch = ''
    substituteInPlace SPIRV-Headers.pc.in \
      --replace '$'{prefix}/@CMAKE_INSTALL_INCLUDEDIR@ @CMAKE_INSTALL_FULL_INCLUDEDIR@
  '';

  meta = with lib; {
    description = "Machine-readable components of the Khronos SPIR-V Registry";
    homepage = "https://github.com/KhronosGroup/SPIRV-Headers";
    license = licenses.mit;
    maintainers = [ maintainers.ralith ];
  };
}
