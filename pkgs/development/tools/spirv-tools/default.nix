{ lib, stdenv, fetchFromGitHub, cmake, python3, spirv-headers }:

stdenv.mkDerivation rec {
  pname = "spirv-tools";
  version = "1.3.275.0";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-Tools";
    rev = "vulkan-sdk-${version}";
    hash = "sha256-RzGvoDt1Qc+f6mZsfs99MxX4YB3yFc5FP92Yx/WGrsI=";
  };

  # The cmake options are sufficient for turning on static building, but not
  # for disabling shared building, just trim the shared lib from the CMake
  # description
  patches = lib.optional stdenv.hostPlatform.isStatic ./no-shared-libs.patch;

  nativeBuildInputs = [ cmake python3 ];

  cmakeFlags = [
    "-DSPIRV-Headers_SOURCE_DIR=${spirv-headers.src}"
    # Avoid blanket -Werror to evade build failures on less
    # tested compilers.
    "-DSPIRV_WERROR=OFF"
  ];

  # https://github.com/KhronosGroup/SPIRV-Tools/issues/3905
  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace '-P ''${CMAKE_CURRENT_SOURCE_DIR}/cmake/write_pkg_config.cmake' \
                '-DCMAKE_INSTALL_FULL_LIBDIR=''${CMAKE_INSTALL_FULL_LIBDIR}
                 -DCMAKE_INSTALL_FULL_INCLUDEDIR=''${CMAKE_INSTALL_FULL_INCLUDEDIR}
                 -P ''${CMAKE_CURRENT_SOURCE_DIR}/cmake/write_pkg_config.cmake'
    substituteInPlace cmake/SPIRV-Tools.pc.in \
      --replace '$'{prefix}/@CMAKE_INSTALL_LIBDIR@ @CMAKE_INSTALL_FULL_LIBDIR@ \
      --replace '$'{prefix}/@CMAKE_INSTALL_INCLUDEDIR@ @CMAKE_INSTALL_FULL_INCLUDEDIR@
    substituteInPlace cmake/SPIRV-Tools-shared.pc.in \
      --replace '$'{prefix}/@CMAKE_INSTALL_LIBDIR@ @CMAKE_INSTALL_FULL_LIBDIR@ \
      --replace '$'{prefix}/@CMAKE_INSTALL_INCLUDEDIR@ @CMAKE_INSTALL_FULL_INCLUDEDIR@
  '';

  meta = with lib; {
    description = "The SPIR-V Tools project provides an API and commands for processing SPIR-V modules";
    homepage = "https://github.com/KhronosGroup/SPIRV-Tools";
    license = licenses.asl20;
    platforms = with platforms; unix ++ windows;
    maintainers = [ maintainers.ralith ];
  };
}
