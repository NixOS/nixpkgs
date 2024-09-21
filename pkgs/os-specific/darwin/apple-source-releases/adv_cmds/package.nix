{
  lib,
  apple-sdk,
  apple-sdk_11,
  bison,
  flex,
  mkAppleDerivation,
  ncurses,
  perl,
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
in
mkAppleDerivation {
  releaseName = "adv_cmds";

  outputs = [
    "out"
    "locale"
    "ps"
    "man"
  ];

  xcodeHash = "sha256-cpoHF++eko3NHGJlKnFONKnGkVRD0zI+bg/XLzWtpN8=";

  postPatch = ''
    # Meson generators require using @BASENAME@ in the output.
    substituteInPlace mklocale/lex.l \
      --replace-fail y.tab.h yacc.tab.h
    substituteInPlace genwrap/lex.l \
      --replace-fail y.tab.h genwrap.tab.h
    substituteInPlace colldef/scan.l \
      --replace-fail y.tab.h parse.tab.h

    # Fix paths to point to the store
    for file in genwrap.c genwrap.8; do
      substituteInPlace genwrap/$file \
        --replace-fail '/usr/local' "$out"
    done

    substituteInPlace localedef/localedef.pl \
      --replace-fail '/usr/bin/perl' '${lib.getExe perl}' \
      --replace-fail '/usr/bin' "$out/bin" \
      --replace-fail '/usr/share/locale' "$locale/share/locale"
  '';

  env.NIX_CFLAGS_COMPILE = "-I${privateHeaders}/include";

  buildInputs = [
    # Use the 11.3 SDK because CMake depends on adv_cmds.ps, so it can’t simply be omitted when using an older SDK.
    apple-sdk_11
    ncurses
  ];

  nativeBuildInputs = [
    bison
    flex
    perl
    pkg-config
  ];

  mesonFlags = [
    # Even though adv_cmds is built with a newer SDK, the default SDK is still the deployment target.
    # Don’t build packages that use newer APIs unnecessarily.
    (lib.mesonOption "sdk_version" (lib.getVersion apple-sdk))
  ];

  postBuild = ''
    # Build the locales TODO
  '';

  postInstall = ''
    moveToOutput share/locale "$locale"
    moveToOutput bin/ps "$ps"
    ln -s "$ps/bin/ps" "$out/bin/ps"
    mkdir -p "$locale/share/locale"
  '';

  meta = {
    description = "Advanced commands package for Darwin";
    license = [
      lib.licenses.apsl10
      lib.licenses.apsl20
    ];
  };
}
