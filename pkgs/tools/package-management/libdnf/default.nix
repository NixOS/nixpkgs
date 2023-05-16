<<<<<<< HEAD
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
=======
{ lib, stdenv, fetchFromGitHub, cmake, gettext, pkg-config, gpgme, libsolv, openssl, check
, json_c, libmodulemd, libsmartcols, sqlite, librepo, libyaml, rpm, zchunk }:

stdenv.mkDerivation rec {
  pname = "libdnf";
  version = "0.70.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "rpm-software-management";
    repo = pname;
<<<<<<< HEAD
    rev = "refs/tags/${version}";
    hash = "sha256-br3RNqR9/hwvu1V3vG5gFmQCob2Ksz3pPQrBONVOMP0=";
=======
    rev = version;
    sha256 = "sha256-tuHrkL3tL+sCLPxNElVgnb4zQ6OTu65X9pb/cX6vD/w=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    description = "Package management library";
    homepage = "https://github.com/rpm-software-management/libdnf";
    changelog = "https://github.com/rpm-software-management/libdnf/releases/tag/${version}";
=======
    description = "Package management library.";
    homepage = "https://github.com/rpm-software-management/libdnf";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.gpl2Plus;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ rb2k ];
  };
}
