{ lib, stdenv
, darwin
, fetchurl
, makeWrapper
, pkg-config
, poppler_utils
, gitMinimal
, harfbuzz
, icu
, fontconfig
, lua
, libiconv
, makeFontsConf
, gentium
}:

let
  luaEnv = lua.withPackages(ps: with ps; [
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
  ] ++ lib.optionals (lib.versionOlder lua.luaversion "5.2") [
    bit32
  ] ++ lib.optionals (lib.versionOlder lua.luaversion "5.3") [
    compat53
  ]);
in

stdenv.mkDerivation rec {
  pname = "sile";
  version = "0.14.3";

  src = fetchurl {
    url = "https://github.com/sile-typesetter/sile/releases/download/v${version}/${pname}-${version}.tar.xz";
    sha256 = "1n7nlrvhdp6ilpx6agb5w6flss5vbflbldv0495h19fy5fxkb5vz";
  };

  configureFlags = [
    "--with-system-luarocks"
    "--with-manual"
  ];

  nativeBuildInputs = [
    gitMinimal
    pkg-config
    makeWrapper
  ];
  buildInputs = [
    luaEnv
    harfbuzz
    icu
    fontconfig
    libiconv
  ]
  ++ lib.optional stdenv.isDarwin darwin.apple_sdk.frameworks.AppKit
  ;
  checkInputs = [
    poppler_utils
  ];
  passthru = {
    # So it will be easier to inspect this environment, in comparison to others
    inherit luaEnv;
  };

  postPatch = ''
    patchShebangs build-aux/*.sh
  '' + lib.optionalString stdenv.isDarwin ''
    sed -i -e 's|@import AppKit;|#import <AppKit/AppKit.h>|' src/macfonts.m
  '';

  NIX_LDFLAGS = lib.optionalString stdenv.isDarwin "-framework AppKit";

  FONTCONFIG_FILE = makeFontsConf {
    fontDirectories = [
      gentium
    ];
  };

  doCheck = true;

  enableParallelBuilding = true;

  preBuild = lib.optionalString stdenv.cc.isClang ''
    substituteInPlace libtexpdf/dpxutil.c \
      --replace "ASSERT(ht && ht->table && iter);" "ASSERT(ht && iter);"
  '';

  # Hack to avoid TMPDIR in RPATHs.
  preFixup = ''rm -rf "$(pwd)" && mkdir "$(pwd)" '';

  outputs = [ "out" "doc" "man" "dev" ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "A typesetting system";
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
    changelog = "https://github.com/sile-typesetter/sile/raw/v${version}/CHANGELOG.md";
    platforms = platforms.unix;
    maintainers = with maintainers; [ doronbehar alerque ];
    license = licenses.mit;
  };
}
