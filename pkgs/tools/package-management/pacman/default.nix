{ lib
, stdenv
, fetchurl
, asciidoc
, bzip2
, coreutils
, curl
, gpgme
, installShellFiles
, libarchive
, meson
, ninja
, openssl
, perl
, pkg-config
, python3
, runtimeShell
, xz
, zlib
}:

stdenv.mkDerivation rec {
  pname = "pacman";
  version = "6.0.1";

  src = fetchurl {
    url = "https://sources.archlinux.org/other/${pname}/${pname}-${version}.tar.xz";
    hash = "sha256-DbYUVuVqpJ4mDokcCwJb4hAxnmKxVSHynT6TsA079zE=";
  };

  nativeBuildInputs = [
    asciidoc
    coreutils
    installShellFiles
    meson
    ninja
    pkg-config
    python3
  ];

  buildInputs = [
    bzip2
    curl
    gpgme
    libarchive
    openssl
    perl
    xz
    zlib
  ];

  postPatch = ''
    substituteInPlace meson.build \
      --replace "install_dir : SYSCONFDIR" "install_dir : '${placeholder "out"}/etc'" \
      --replace "join_paths(LOCALSTATEDIR, 'lib/pacman/')," "'${placeholder "out"}/var/lib/pacman/'," \
      --replace "join_paths(LOCALSTATEDIR, 'cache/pacman/pkg/')," "'${placeholder "out"}/var/cache/pacman/pkg/',"

    substituteInPlace doc/meson.build \
      --replace "/bin/true" "${coreutils}/bin/true"

    substituteInPlace scripts/repo-add.sh.in \
      --replace bsdtar "${libarchive}/bin/bsdtar"
  '';

  mesonFlags = [
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    "-Dmakepkg-template-dir=${placeholder "out"}/share/makepkg-template"
    "-Dscriptlet-shell=${runtimeShell}"
  ];

  postInstall = ''
    installShellCompletion --bash scripts/pacman --zsh scripts/_pacman
  '';

  meta = with lib; {
    description = "A simple library-based package manager";
    homepage = "https://archlinux.org/pacman/";
    changelog = "https://gitlab.archlinux.org/pacman/pacman/-/raw/v${version}/NEWS";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mt-caret ];
  };
}
