{ lib, stdenv, fetchFromGitHub, cmake, python3, spirv-headers }:

stdenv.mkDerivation rec {
  pname = "spirv-tools";
  version = "2023.3.rc1";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-Tools";
    rev = "v${version}";
    hash = "sha256-HV7jNvgTRRGnhurtT5pf5f5gzUOmr3iWNcDc8TE4ICQ=";
  };

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
    platforms = platforms.unix;
    maintainers = [ maintainers.ralith ];
  };
}
