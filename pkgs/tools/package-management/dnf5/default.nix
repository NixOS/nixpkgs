{ lib
, stdenv
, fetchFromGitHub
, cmake
, createrepo_c
, gettext
, help2man
, pkg-config
, cppunit
, fmt
, glib
, json_c
, libmodulemd
, libpeas
, librepo
, libsmartcols
, libsolv
, libxml2
, rpm
, sdbus-cpp
, sqlite
, systemd
, toml11
, zchunk
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dnf5";
  version = "5.1.3";

  src = fetchFromGitHub {
    owner = "rpm-software-management";
    repo = "dnf5";
    rev = finalAttrs.version;
    hash = "sha256-Z1Pbi3dGqAQeVaagpOUsjYsT46DAlcFHsDhQzyeCCfY=";
  };

  nativeBuildInputs = [ cmake createrepo_c gettext help2man pkg-config ];
  buildInputs = [
    cppunit
    fmt
    glib
    json_c
    libmodulemd
    libpeas
    librepo
    libsmartcols
    libsolv
    libxml2
    rpm
    sdbus-cpp
    sqlite
    systemd
    toml11
    zchunk
  ];

  # workaround for https://gcc.gnu.org/bugzilla/show_bug.cgi?id=105329
  NIX_CFLAGS_COMPILE = "-Wno-restrict -Wno-maybe-uninitialized";

  cmakeFlags = [
    "-DWITH_PERL5=OFF"
    "-DWITH_PYTHON3=OFF"
    "-DWITH_RUBY=OFF"
    "-DWITH_TESTS=OFF"
    # TODO: fix man installation paths
    "-DWITH_MAN=OFF"
    # the cmake package does not handle absolute CMAKE_INSTALL_INCLUDEDIR correctly
    # (setting it to an absolute path causes include files to go to $out/$out/include,
    #  because the absolute path is interpreted with root at $out).
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
    "-DCMAKE_INSTALL_LIBDIR=lib"
  ];

  prePatch = ''
    substituteInPlace dnf5daemon-server/dbus/CMakeLists.txt \
      --replace '/etc' "$out/etc" \
      --replace '/usr' "$out"
    substituteInPlace dnf5daemon-server/polkit/CMakeLists.txt \
      --replace '/usr' "$out"
    substituteInPlace dnf5/CMakeLists.txt \
      --replace '/etc/bash_completion.d' "$out/etc/bash_completion.d"
  '';

  dontFixCmake = true;

  meta = with lib; {
    description = "Next-generation RPM package management system";
    homepage = "https://github.com/rpm-software-management/dnf5";
    license = licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ malt3 ];
    platforms = platforms.linux ++ platforms.darwin;
  };
})
