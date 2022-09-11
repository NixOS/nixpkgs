{ lib, stdenv, fetchFromGitHub, cmake, gettext, pkg-config, gpgme, libsolv, openssl, check
, json_c, libmodulemd, libsmartcols, sqlite, librepo, libyaml, rpm, zchunk }:

stdenv.mkDerivation rec {
  pname = "libdnf";
  version = "0.69.0";

  src = fetchFromGitHub {
    owner = "rpm-software-management";
    repo = pname;
    rev = version;
    sha256 = "sha256-Mc9yI18D4OYv8l4axQ8W0XZ8HfmEZ5IhHC6/uKkv0Ec=";
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

  # See https://github.com/NixOS/nixpkgs/issues/107428
  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace "enable_testing()" "" \
      --replace "add_subdirectory(tests)" ""
  '';

  cmakeFlags = [
    "-DWITH_GTKDOC=OFF"
    "-DWITH_HTML=OFF"
    "-DWITH_BINDINGS=OFF"
  ];

  meta = with lib; {
    description = "Package management library.";
    homepage = "https://github.com/rpm-software-management/libdnf";
    license = licenses.gpl2Plus;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ rb2k ];
  };
}
