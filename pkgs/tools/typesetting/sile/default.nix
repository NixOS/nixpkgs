{ stdenv, darwin, fetchurl, makeWrapper, pkgconfig, autoconf, automake
, harfbuzz, icu
, fontconfig, lua, libiconv
, makeFontsConf, gentium
}:

with stdenv.lib;

let
  luaEnv = lua.withPackages(ps: with ps;[cassowary cosmo compat53 linenoise lpeg lua-zlib lua_cliargs luaepnf luaexpat luafilesystem luarepl luasec luasocket stdlib vstruct]);

in

stdenv.mkDerivation rec {
  pname = "sile";
  version = "0.10.4";

  src = fetchurl {
    url = "https://github.com/sile-typesetter/sile/releases/download/v${version}/${pname}-${version}.tar.bz2";
    sha256 = "08j2vv6spnzz8bsh62wbdv1pjiziiba71cadscsy5hw6pklzndni";
  };

  configureFlags = [ "--with-system-luarocks" ];

  nativeBuildInputs = [ autoconf automake pkgconfig makeWrapper ];
  buildInputs = [ harfbuzz icu fontconfig libiconv luaEnv ]
  ++ optional stdenv.isDarwin darwin.apple_sdk.frameworks.AppKit
  ;

  preConfigure = optionalString stdenv.isDarwin ''
    sed -i -e 's|@import AppKit;|#import <AppKit/AppKit.h>|' src/macfonts.m
  '';

  NIX_LDFLAGS = optionalString stdenv.isDarwin "-framework AppKit";

  FONTCONFIG_FILE = makeFontsConf {
    fontDirectories = [
      gentium
    ];
  };

  # TODO: needs to tweak Makefile-fonts to avoid download fonts
  doCheck = false; /*stdenv.targetPlatform == stdenv.hostPlatform
  && ! stdenv.isAarch64 # random seg. faults
  && ! stdenv.isDarwin; # dy lib not found
 */

  enableParallelBuilding = true;

  preBuild = stdenv.lib.optionalString stdenv.cc.isClang ''
    substituteInPlace libtexpdf/dpxutil.c \
      --replace "ASSERT(ht && ht->table && iter);" "ASSERT(ht && iter);"
  '';

  checkTarget = "examples";

  postInstall = ''
    install -D -t $out/share/doc/sile documentation/sile.pdf
  '';

  # Hack to avoid TMPDIR in RPATHs.
  preFixup = ''rm -rf "$(pwd)" && mkdir "$(pwd)" '';

  outputs = [ "out" "doc" ];

  meta = {
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
