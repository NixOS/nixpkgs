{ stdenv, darwin, fetchurl, makeWrapper, pkgconfig
, harfbuzz, icu, lpeg, luaexpat, luazlib, luafilesystem, luasocket, luasec
, fontconfig, lua, libiconv
}:

with stdenv.lib;

let

  libs          = [ lpeg luaexpat luazlib luafilesystem luasocket luasec ];
  getPath       = lib : type : "${lib}/lib/lua/${lua.luaversion}/?.${type};${lib}/share/lua/${lua.luaversion}/?.${type}";
  getLuaPath    = lib : getPath lib "lua";
  getLuaCPath   = lib : getPath lib "so";
  luaPath       = concatStringsSep ";" (map getLuaPath libs);
  luaCPath      = concatStringsSep ";" (map getLuaCPath libs);

in

stdenv.mkDerivation rec {
  name = "sile-${version}";
  version = "0.9.5";

  src = fetchurl {
    url = "https://github.com/simoncozens/sile/releases/download/v${version}/${name}.tar.bz2";
    sha256 = "0m80rkbkma11xsr7bbrmq5mdwi5k79clsrmc75blbnsf9wqil8dp";
  };

  nativeBuildInputs = [pkgconfig makeWrapper];
  buildInputs = [ harfbuzz icu lua fontconfig libiconv ]
  ++ libs
  ++ optional stdenv.isDarwin darwin.apple_sdk.frameworks.AppKit
  ;

  preConfigure = optionalString stdenv.isDarwin ''
    sed -i -e 's|@import AppKit;|#import <AppKit/AppKit.h>|' src/macfonts.m
  '';

  NIX_LDFLAGS = optionalString stdenv.isDarwin "-framework AppKit";

  LUA_PATH = luaPath;
  LUA_CPATH = luaCPath;

  postInstall = ''
    wrapProgram $out/bin/sile \
      --set LUA_PATH "${luaPath};" \
      --set LUA_CPATH "${luaCPath};" \
  '';

  # Hack to avoid TMPDIR in RPATHs.
  preFixup = ''rm -rf "$(pwd)" && mkdir "$(pwd)" '';

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
    homepage = http://www.sile-typesetter.org;
    platforms = platforms.unix;
    license = licenses.mit;
  };
}
