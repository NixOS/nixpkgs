{ lib
, stdenv
, fetchFromGitHub
, cmake
, gettext
, pkg-config
, gpgme
, libsolv
, openssl
, check
, json_c
, libmodulemd
, libsmartcols
, sqlite
, librepo
, libyaml
, rpm
, zchunk
}:

stdenv.mkDerivation rec {
  pname = "libdnf";
  version = "0.70.2";

  src = fetchFromGitHub {
    owner = "rpm-software-management";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-br3RNqR9/hwvu1V3vG5gFmQCob2Ksz3pPQrBONVOMP0=";
  };

  nativeBuildInputs = [
    cmake
    gettext
    pkg-config
  ];

  buildInputs = [
    check
    gpgme
    openssl
    json_c
    libsmartcols
    libyaml
    libmodulemd
    zchunk
  ];

  propagatedBuildInputs = [
    sqlite
    libsolv
    librepo
    rpm
  ];

  # See https://github.com/NixOS/nixpkgs/issues/107430
  prePatch = ''
    cp ${libsolv}/share/cmake/Modules/FindLibSolv.cmake cmake/modules/
  '';

  postPatch = ''
    # See https://github.com/NixOS/nixpkgs/issues/107428
    substituteInPlace CMakeLists.txt \
      --replace "enable_testing()" "" \
      --replace "add_subdirectory(tests)" ""

    # https://github.com/rpm-software-management/libdnf/issues/1518
    substituteInPlace libdnf/libdnf.pc.in \
      --replace '$'{prefix}/@CMAKE_INSTALL_LIBDIR@ @CMAKE_INSTALL_FULL_LIBDIR@
  '';

  cmakeFlags = [
    "-DWITH_GTKDOC=OFF"
    "-DWITH_HTML=OFF"
    "-DWITH_BINDINGS=OFF"
  ];

  meta = with lib; {
    description = "Package management library";
    homepage = "https://github.com/rpm-software-management/libdnf";
    changelog = "https://github.com/rpm-software-management/libdnf/releases/tag/${version}";
    license = licenses.gpl2Plus;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ rb2k ];
  };
}
