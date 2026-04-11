{
  lib,
  apple-sdk,
  bison,
  flex,
  libxo,
  mkAppleDerivation,
  ncurses,
  pkg-config,
  stdenvNoCC,
}:

let
  Libc = apple-sdk.sourceRelease "Libc";
  libplatform = apple-sdk.sourceRelease "libplatform";
  xnu = apple-sdk.sourceRelease "xnu";

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
    "ps"
    "man"
  ];

  xcodeHash = "sha256-QhkylTnnCy4qG8fpUMlKqDGKz58jysL0YF4lFGJzPzE=";

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
  '';

  env.NIX_CFLAGS_COMPILE = "-I${privateHeaders}/include";

  buildInputs = [
    libxo
    ncurses
  ];

  nativeBuildInputs = [
    bison
    flex
    pkg-config
  ];

  postInstall = ''
    moveToOutput bin/ps "$ps"
    ln -s "$ps/bin/ps" "$out/bin/ps"
  '';

  meta = {
    description = "Advanced commands package for Darwin";
    license = [
      lib.licenses.apsl10
      lib.licenses.apsl20
    ];
  };
}
