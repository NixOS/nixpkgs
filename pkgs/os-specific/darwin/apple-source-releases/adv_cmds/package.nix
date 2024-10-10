{
  lib,
  apple-sdk,
  apple-sdk_11,
  bison,
  bmake,
  buildPackages,
  fetchFromGitHub,
  flex,
  libxo,
  mkAppleDerivation,
  ncurses,
  pkg-config,
  stdenvNoCC,
}:

let
  Libc = apple-sdk_11.sourceRelease "Libc";
  libplatform = apple-sdk_11.sourceRelease "libplatform";
  xnu = apple-sdk_11.sourceRelease "xnu";

  privateHeaders = stdenvNoCC.mkDerivation {
    name = "adv_cmds-deps-private-headers";

    buildCommand = ''
      install -D -m644 -t "$out/include" \
        '${libplatform}/private/_simple.h' \
        '${Libc}/nls/FreeBSD/msgcat.h'

      install -D -m644 -t "$out/include/System/sys" \
        '${xnu}/bsd/sys/persona.h' \
        '${xnu}/bsd/sys/proc.h'
    '';
  };

  # This data is not exactly what macOS has, but it’s close. The actual source does not appear to be part of the
  # source releases anymore. There is some older data, but it is not compatible with the current version of adv_cmds.
  localeSrc = fetchFromGitHub {
    owner = "freebsd";
    repo = "freebsd-src";
    rev = "release/14.1.0";
    hash = "sha256-k4Bs5zR17wHPYrL04aUyPswYGdCWVcRYZOTCDp2VTfk=";
  };

in
mkAppleDerivation {
  releaseName = "adv_cmds";

  outputs = [
    "out"
    "locale"
    "ps"
    "man"
  ];

  xcodeHash = "sha256-2p/JyMPw6acHphvzkaJXPXGwxCUEoxryCejww5kPHvQ=";

  patches = [
    # Use older API when running on systems prior to 11.3.
    ./patches/0001-Fall-back-to-task_read_pid-on-older-systems.patch
  ];

  postPatch = ''
    # Meson generators require using @BASENAME@ in the output.
    substituteInPlace mklocale/lex.l \
      --replace-fail y.tab.h yacc.tab.h
    substituteInPlace genwrap/lex.l \
      --replace-fail y.tab.h genwrap.tab.h
    substituteInPlace colldef/scan.l \
      --replace-fail y.tab.h parse.tab.h

    find localedef -name '*.c' -exec sed -e 's/parser.h/parser.tab.h/' -i {} \;

    # Fix paths to point to the store
    for file in genwrap.c genwrap.8; do
      substituteInPlace genwrap/$file \
        --replace-fail '/usr/local' "$out"
    done

    # Set up the locale data
    unpackFile '${localeSrc}'
    LOCALE_TOPLEVEL=$PWD/source
    chmod -R u+w "$LOCALE_TOPLEVEL/share"

    # Remove these from `SUBDIRS` with sed because they’re always built otherwise
    sed -i -e '/keys\|misc\|skel\|tabset\|termcap/d' "$LOCALE_TOPLEVEL/share/Makefile"

    # Don’t set installed locale data ownership to root:wheel (let the builder take care of that).
    substituteInPlace "$LOCALE_TOPLEVEL/share/mk/bsd.dirs.mk" \
      --replace-fail '-g ''${''${dir}_GRP}' "" \
      --replace-fail '-o ''${''${dir}_OWN}' ""

    substituteInPlace "$LOCALE_TOPLEVEL/share/mk/bsd.files.mk" \
      --replace-fail '-g ''${''${group}GRP_''${file}}' "" \
      --replace-fail '-o ''${''${group}OWN_''${file}}' ""
  '';

  dontUpdateAutotoolsGnuConfigScripts = true;

  preConfigure = ''
    makeFlags+=(-m "$LOCALE_TOPLEVEL/share/mk")
  '';

  env.NIX_CFLAGS_COMPILE = "-I${privateHeaders}/include";

  makeFlags = [
    "-DWITH_LOCALES"
    "-DWITHOUT_BSNMP"
    "-DWITHOUT_CDDL"
    "-DWITHOUT_DICT"
    "-DWITHOUT_EXAMPLES"
    "-DWITHOUT_ICONV"
    "-DWITHOUT_MAKE"
    "-DWITHOUT_MAN"
    "-DWITHOUT_SENDMAIL"
    "-DWITHOUT_SHAREDOCS"
    "-DWITHOUT_SYSCONS"
    "-DWITHOUT_TESTS"
    "-DWITHOUT_VT"
    "-DWITHOUT_ZONEINFO"
    "-C"
    "share"
  ];

  buildInputs = [
    # Use the 11.3 SDK because CMake depends on adv_cmds.ps, so it can’t simply be omitted when using an older SDK.
    apple-sdk_11
    libxo
    ncurses
  ];

  nativeBuildInputs = [
    bison
    bmake
    flex
    pkg-config
  ];

  enableParallelBuilding = true;

  mesonFlags = [
    # Even though adv_cmds is built with a newer SDK, the default SDK is still the deployment target.
    # Don’t built packages that use newer APIs unnecessarily.
    (lib.mesonOption "sdk_version" (lib.getVersion apple-sdk))
  ];

  buildPhase =
    ''
      ninjaBuildPhase
    ''
    +
      # Cross-compilation requires using adv_cmds from the buildPlatform.
      (
        if stdenvNoCC.buildPlatform.canExecute stdenvNoCC.hostPlatform then
          ''
            export PATH=$PWD:$PATH
          ''
        else
          ''
            export PATH=$PWD:${lib.getBin buildPackages.darwin.adv_cmds}/bin
          ''
      )
    + ''
      pushd "$LOCALE_TOPLEVEL"
      bmakeBuildPhase
      popd
    '';

  enableParallelInstalling = true;

  installFlags = [
    "SHAREDIR=${placeholder "locale"}/share"
    "INSTALL_SYMLINK=ln -s"
    "SYMLINK="
  ];

  installPhase = ''
    ninjaInstallPhase

    moveToOutput bin/ps "$ps"
    ln -s "$ps/bin/ps" "$out/bin/ps"

    cd "$LOCALE_TOPLEVEL"
    bmakeInstallPhase
  '';

  meta = {
    description = "Advanced commands package for Darwin";
    license = [
      lib.licenses.apsl10
      lib.licenses.apsl20
    ];
  };
}
