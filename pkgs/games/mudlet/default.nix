{ fetchurl, unzip, stdenv, makeWrapper, qtbase, yajl, libzip, hunspell
, boost, lua5_1, luafilesystem, luazip, lrexlib-pcre, luasql-sqlite3, qmake }:

stdenv.mkDerivation rec {
  name = "mudlet-${version}";
  version = "3.0.0-delta";

  src = fetchurl {
    url = "https://github.com/Mudlet/Mudlet/archive/Mudlet-${version}.tar.gz";
    sha256 = "08fhqd323kgz5s17ac5z9dhkjxcmwvcmvhzy0x1vw4rayhijfrd7";
  };

  nativeBuildInputs = [ makeWrapper qmake ];
  buildInputs = [
    unzip qtbase lua5_1 hunspell libzip yajl boost
    luafilesystem luazip lrexlib-pcre luasql-sqlite3
  ];

  preConfigure = "cd src";

  installPhase = let
    luaZipPath = "${luazip}/lib/lua/5.1/?.so";
    luaFileSystemPath = "${luafilesystem}/lib/lua/5.1/?.so";
    lrexlibPath = "${lrexlib-pcre}/lib/lua/5.1/?.so";
    luasqlitePath = "${luasql-sqlite3}/lib/lua/5.1/?.so";
  in ''
    mkdir -pv $out/bin
    cp mudlet $out
    cp -r mudlet-lua $out

    makeWrapper $out/mudlet $out/bin/mudlet \
      --set LUA_CPATH "${luaFileSystemPath};${luaZipPath};${lrexlibPath};${luasqlitePath}" \
      --run "cd $out";
  '';

  patches = [ ./libs.patch ];

  meta = {
    description = "Crossplatform mud client";
    homepage = http://mudlet.org/;
    maintainers = [ stdenv.lib.maintainers.wyvie ];
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.gpl2;
    broken = true;
  };
}
