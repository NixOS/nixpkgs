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
    luautf8
    penlight
    stdlib
    vstruct
  ]);
in

stdenv.mkDerivation rec {
  pname = "sile";
  version = "0.12.2";

  src = fetchurl {
    url = "https://github.com/sile-typesetter/sile/releases/download/v${version}/${pname}-${version}.tar.xz";
    sha256 = "0ilnb4gmrj5h5i4q7pl2pyd6n2rdc358x7r163ap0dszypq6f0si";
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
    harfbuzz
    icu
    fontconfig
    libiconv
    luaEnv
  ]
  ++ lib.optional stdenv.isDarwin darwin.apple_sdk.frameworks.AppKit
  ;
  checkInputs = [
    poppler_utils
  ];

  preConfigure = ''
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
    broken = stdenv.isDarwin;   # https://github.com/NixOS/nixpkgs/issues/23018
    maintainers = with maintainers; [ doronbehar alerque ];
    license = licenses.mit;
  };
}
