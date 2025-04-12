{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  gettext,
  pkg-config,
  libsolv,
  openssl,
  check,
  json_c,
  libmodulemd,
  libsmartcols,
  sqlite,
  librepo,
  libyaml,
  rpm,
  zchunk,
  cppunit,
  python,
  swig,
  pcre2,
  sphinx,
}:

stdenv.mkDerivation rec {
  pname = "libdnf";
  version = "0.73.4";

  outputs = [
    "out"
    "dev"
    "py"
  ];

  src = fetchFromGitHub {
    owner = "rpm-software-management";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-O8pN2WFHWxZpr2JEPsQOmkc+7qnMVnptmGJCVxMmSLo=";
  };

  nativeBuildInputs = [
    cmake
    gettext
    pkg-config
  ];

  buildInputs = [
    check
    cppunit
    openssl
    json_c
    libsmartcols
    libyaml
    libmodulemd
    zchunk
    python
    swig
    sphinx
    pcre2.dev
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

  patches = [ ./fix-python-install-dir.patch ];

  postPatch = ''
    # https://github.com/rpm-software-management/libdnf/issues/1518
    substituteInPlace libdnf/libdnf.pc.in \
      --replace '$'{prefix}/@CMAKE_INSTALL_LIBDIR@ @CMAKE_INSTALL_FULL_LIBDIR@
    substituteInPlace cmake/modules/FindPythonInstDir.cmake \
      --replace "@PYTHON_INSTALL_DIR@" "$out/${python.sitePackages}"
  '';

  cmakeFlags = [
    "-DWITH_GTKDOC=OFF"
    "-DWITH_HTML=OFF"
    "-DPYTHON_DESIRED=${lib.head (lib.splitString [ "." ] python.version)}"
  ];

  postInstall = ''
    rm -r $out/${python.sitePackages}/hawkey/test
  '';

  postFixup = ''
    moveToOutput "lib/${python.libPrefix}" "$py"
  '';

  meta = {
    description = "Package management library";
    homepage = "https://github.com/rpm-software-management/libdnf";
    changelog = "https://github.com/rpm-software-management/libdnf/releases/tag/${version}";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [
      rb2k
      katexochen
    ];
  };
}
