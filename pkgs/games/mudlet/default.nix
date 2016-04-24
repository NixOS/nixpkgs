{ fetchurl, unzip, stdenv, makeWrapper, qtbase, yajl, libzip, hunspell
, boost, lua5_1, luafilesystem, luazip, lrexlib, luasqlite3, qmakeHook }:

stdenv.mkDerivation rec {
  name = "mudlet-${version}";
  version = "3.0.0-delta";

  src = fetchurl {
    url = "https://github.com/Mudlet/Mudlet/archive/Mudlet-${version}.tar.gz";
    sha256 = "08fhqd323kgz5s17ac5z9dhkjxcmwvcmvhzy0x1vw4rayhijfrd7";
  };

  buildInputs = [
    unzip qtbase lua5_1 hunspell libzip yajl boost makeWrapper
    luafilesystem luazip lrexlib luasqlite3 qmakeHook
  ];

  preConfigure = "cd src";

  installPhase = let
    luaZipPath = "${luazip}/lib/lua/5.1/?.so";
    luaFileSystemPath = "${luafilesystem}/lib/lua/5.1/?.so";
    lrexlibPath = "${lrexlib}/lib/lua/5.1/?.so";
    luasqlitePath = "${luasqlite3}/lib/lua/5.1/?.so";
  in ''
    mkdir -pv $out/bin
    cp mudlet $out
    cp -r mudlet-lua $out

    makeWrapper $out/mudlet $out/bin/mudlet \
      --set LUA_CPATH "\"${luaFileSystemPath};${luaZipPath};${lrexlibPath};${luasqlitePath}\"" \
      --run "cd $out";
  '';

  patches = [ ./libs.patch ];

  meta = {
    description = "Crossplatform mud client";
    homepage = http://mudlet.org/;
    maintainers = [ stdenv.lib.maintainers.wyvie ];
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.gpl2;
  };
}
