{ gcc9Stdenv, stdenv, fetchFromGitHub, cmake, gettext, pkg-config, gpgme, libsolv, openssl, check
, pcre, json_c, libmodulemd, libsmartcols, sqlite, librepo, libyaml, rpm }:

gcc9Stdenv.mkDerivation rec {
  pname = "libdnf";
  version = "0.55.2";

  src = fetchFromGitHub {
    owner = "rpm-software-management";
    repo = pname;
    rev = version;
    sha256 = "0hiydwfa90nsrqk5ffa6ks1g73wnsgjgq7z7gwq9jj76a7gpfbfq";
  };

  patches = stdenv.lib.optionals stdenv.isDarwin [ ./darwin.patch ];

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
    "-DWITH_ZCHUNK=OFF"
  ];

  meta = with stdenv.lib; {
    description = "Package management library.";
    homepage = "https://github.com/rpm-software-management/libdnf";
    license = licenses.gpl2Plus;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ rb2k ];
  };
}
