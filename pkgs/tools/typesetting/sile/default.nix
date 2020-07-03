{ stdenv
, darwin
, fetchurl
, makeWrapper
, pkgconfig
, autoconf
, automake
, harfbuzz
, icu
, poppler_utils
, fontconfig
, lua
, libiconv
, makeFontsConf
, gentium
}:

let
  luaEnv = lua.withPackages(ps: with ps; [
    cassowary
    cosmo
    compat53
    linenoise
    lpeg
    lua-zlib
    lua_cliargs
    luaepnf
    luaexpat
    luafilesystem
    luarepl
    luasec
    luasocket
    stdlib
    vstruct
  ]);
in

stdenv.mkDerivation rec {
  pname = "sile";
  version = "0.10.5";

  src = fetchurl {
    url = "https://github.com/sile-typesetter/sile/releases/download/v${version}/${pname}-${version}.tar.bz2";
    sha256 = "16sb9dy0a3mq80qm9b4hjf0d2q5z1aqli439xlx75fj2y8xf4kx1";
  };

  configureFlags = [
    "--with-system-luarocks"
  ];

  nativeBuildInputs = [
    autoconf
    automake
    pkgconfig
    makeWrapper
  ];
  buildInputs = [
    harfbuzz
    icu
    fontconfig
    libiconv
    luaEnv
  ]
    ++ stdenv.lib.optionals stdenv.isDarwin [
      darwin.apple_sdk.frameworks.AppKit
    ]
  ;
  checkInputs = [
    poppler_utils
  ];

  preConfigure = stdenv.lib.optionalString stdenv.isDarwin ''
    sed -i -e 's|@import AppKit;|#import <AppKit/AppKit.h>|' src/macfonts.m
  '';

  NIX_LDFLAGS = stdenv.lib.optionalString stdenv.isDarwin "-framework AppKit";

  FONTCONFIG_FILE = makeFontsConf {
    fontDirectories = [
      gentium
    ];
  };

  doCheck = true;

  enableParallelBuilding = true;

  preBuild = stdenv.lib.optionalString stdenv.cc.isClang ''
    substituteInPlace libtexpdf/dpxutil.c \
      --replace "ASSERT(ht && ht->table && iter);" "ASSERT(ht && iter);"
  '';

  checkTarget = "check";

  postInstall = ''
    install -D -t $doc/share/doc/sile documentation/sile.pdf
  '';

  # Hack to avoid TMPDIR in RPATHs.
  preFixup = ''
    rm -rf "$(pwd)" && mkdir "$(pwd)"
  '';

  outputs = [ "out" "man" "dev" "doc" ];

  meta = with stdenv.lib; {
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
    homepage = "https://sile-typesetter.org/";
    platforms = platforms.unix;
    license = licenses.mit;
  };
}
