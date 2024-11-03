{
  # Nix specific packaging and flake tooling
  darwin,
  fetchurl,
  gitMinimal,
  lib,
  makeFontsConf,
  makeWrapper,
  runCommand,
  stdenv,

  # Upstream build time dependencies
  pkg-config,
  poppler_utils,

  # Upstream run time dependencies
  fontconfig,
  gentium,
  harfbuzz,
  icu,
  libiconv,
  lua,

  # This package
  sile,
}:

let
  luaEnv = lua.withPackages (
    ps:
    with ps;
    [
      cassowary
      cldr
      cosmo
      fluent
      linenoise
      loadkit
      lpeg
      lua-zlib
      lua_cliargs
      luaepnf
      luaexpat
      luafilesystem
      luarepl
      luasec
      luasocket
      luautf8
      penlight
      vstruct
    ]
    ++ lib.optionals (lib.versionOlder lua.luaversion "5.2") [
      bit32
    ]
    ++ lib.optionals (lib.versionOlder lua.luaversion "5.3") [
      compat53
    ]
  );

in
stdenv.mkDerivation (finalAttrs: {
  pname = "sile";
  version = "0.14.17";

  src = fetchurl {
    url = "https://github.com/sile-typesetter/sile/releases/download/v${finalAttrs.version}/sile-${finalAttrs.version}.tar.xz";
    sha256 = "sha256-f4m+3s7au1FoJQrZ3YDAntKJyOiMPQ11bS0dku4GXgQ=";
  };

  nativeBuildInputs = [
    gitMinimal
    makeWrapper
    pkg-config
  ];

  buildInputs = [
    fontconfig
    harfbuzz
    icu
    libiconv
    luaEnv
  ] ++ lib.optional stdenv.hostPlatform.isDarwin darwin.apple_sdk.frameworks.AppKit;

  configureFlags = [
    "--with-system-luarocks"
    "--with-manual"
  ];

  postPatch =
    ''
      patchShebangs build-aux/*.sh
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      sed -i -e 's|@import AppKit;|#import <AppKit/AppKit.h>|' src/macfonts.m
    '';

  NIX_LDFLAGS = lib.optionalString stdenv.hostPlatform.isDarwin "-framework AppKit";

  FONTCONFIG_FILE = makeFontsConf {
    fontDirectories = [
      gentium
    ];
  };

  enableParallelBuilding = true;

  preBuild = lib.optionalString stdenv.cc.isClang ''
    substituteInPlace libtexpdf/dpxutil.c \
      --replace "ASSERT(ht && ht->table && iter);" "ASSERT(ht && iter);"
  '';

  passthru = {
    # So it will be easier to inspect this environment, in comparison to others
    inherit luaEnv;
    # Copied from Makefile.am
    tests.test = lib.optionalAttrs (!(stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64)) (
      runCommand "sile-test"
        {
          nativeBuildInputs = [
            poppler_utils
            sile
          ];
          inherit (finalAttrs) FONTCONFIG_FILE;
        }
        ''
          output=$(mktemp -t selfcheck-XXXXXX.pdf)
          echo "<sile>foo</sile>" | sile -o $output -
          pdfinfo $output | grep "SILE v${finalAttrs.version}" > $out
        ''
    );
  };

  # remove forbidden references to $TMPDIR
  preFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    for f in "$out"/bin/*; do
      if isELF "$f"; then
        patchelf --shrink-rpath --allowed-rpath-prefixes "$NIX_STORE" "$f"
      fi
    done
  '';

  outputs = [
    "out"
    "doc"
    "man"
    "dev"
  ];

  meta = with lib; {
    mainProgram = "sile";
    description = "Typesetting system";
    longDescription = ''
      SILE is a typesetting system; its job is to produce beautiful
      printed documents. Conceptually, SILE is similar to TeX—from
      which it borrows some concepts and even syntax and
      algorithms—but the similarities end there. Rather than being a
      derivative of the TeX family SILE is a new typesetting and
      layout engine written from the ground up using modern
      technologies and borrowing some ideas from graphical systems
      such as InDesign.
    '';
    homepage = "https://sile-typesetter.org";
    changelog = "https://github.com/sile-typesetter/sile/raw/v${finalAttrs.version}/CHANGELOG.md";
    platforms = platforms.unix;
    maintainers = with maintainers; [
      doronbehar
      alerque
    ];
    license = licenses.mit;
  };
})
