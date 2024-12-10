{
  lib,
  stdenv,
  fetchFromGitLab,
  asciidoc,
  binutils,
  coreutils,
  curl,
  gpgme,
  installShellFiles,
  libarchive,
  makeWrapper,
  meson,
  ninja,
  openssl,
  perl,
  pkg-config,
  zlib,

  # Compression tools in scripts/libmakepkg/util/compress.sh.in
  gzip,
  bzip2,
  xz,
  zstd,
  lrzip,
  lzop,
  ncompress,
  lz4,
  lzip,

  # pacman-key runtime dependencies
  gawk,
  gettext,
  gnugrep,
  gnupg,

  # Tells pacman where to find ALPM hooks provided by packages.
  # This path is very likely to be used in an Arch-like root.
  sysHookDir ? "/usr/share/libalpm/hooks/",
}:

stdenv.mkDerivation (final: {
  pname = "pacman";
  version = "6.1.0";

  src = fetchFromGitLab {
    domain = "gitlab.archlinux.org";
    owner = "pacman";
    repo = "pacman";
    rev = "v${final.version}";
    hash = "sha256-uHBq1A//YSqFATlyqjC5ZgmvPkNKqp7sVew+nbmLH78=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    asciidoc
    gettext
    installShellFiles
    libarchive
    makeWrapper
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    curl
    gpgme
    libarchive
    openssl
    perl
    zlib
  ];

  patches = [
    ./dont-create-empty-dirs.patch
  ];

  postPatch =
    let
      compressionTools = [
        gzip
        bzip2
        xz
        zstd
        lrzip
        lzop
        ncompress
        lz4
        lzip
      ];
    in
    ''
      echo 'export PATH=${lib.makeBinPath compressionTools}:$PATH' >> scripts/libmakepkg/util/compress.sh.in
      substituteInPlace meson.build \
        --replace "install_dir : SYSCONFDIR" "install_dir : '$out/etc'" \
        --replace "join_paths(DATAROOTDIR, 'libalpm/hooks/')" "'${sysHookDir}'" \
        --replace "join_paths(PREFIX, DATAROOTDIR, get_option('keyringdir'))" "'\$KEYRING_IMPORT_DIR'" \
        --replace "join_paths(SYSCONFDIR, 'makepkg.conf.d/')" "'$out/etc/makepkg.conf.d/'"
      substituteInPlace doc/meson.build \
        --replace "/bin/true" "${coreutils}/bin/true"
      substituteInPlace scripts/repo-add.sh.in \
        --replace bsdtar "${libarchive}/bin/bsdtar"
      substituteInPlace scripts/pacman-key.sh.in \
        --replace "local KEYRING_IMPORT_DIR='@keyringdir@'" "" \
        --subst-var-by keyringdir '\$KEYRING_IMPORT_DIR'
    '';

  mesonFlags = [
    "--sysconfdir=/etc"
    "--localstatedir=/var"
  ];

  hardeningDisable = [ "fortify3" ];

  postInstall = ''
    installShellCompletion --bash scripts/pacman --zsh scripts/_pacman
    wrapProgram $out/bin/makepkg \
      --prefix PATH : ${lib.makeBinPath [ binutils ]}
    wrapProgram $out/bin/pacman-key \
      --prefix PATH : ${
        lib.makeBinPath [
          "${placeholder "out"}"
          coreutils
          gawk
          gettext
          gnugrep
          gnupg
        ]
      }
  '';

  meta = with lib; {
    description = "A simple library-based package manager";
    homepage = "https://archlinux.org/pacman/";
    changelog = "https://gitlab.archlinux.org/pacman/pacman/-/raw/v${final.version}/NEWS";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    mainProgram = "pacman";
    maintainers = with maintainers; [ samlukeyes123 ];
  };
})
