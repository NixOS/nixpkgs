{ fetchurl, unzip, stdenv, makeWrapper, qtbase, yajl, libzip, hunspell
, boost, lua
, qmake }:

let
  luaEnv = lua.withPackages(ps: with ps; [ luazip lrexlib luasqlite3 ]);
in
stdenv.mkDerivation rec {
  name = "mudlet-${version}";
  version = "3.0.0-delta";

  src = fetchurl {
    url = "https://github.com/Mudlet/Mudlet/archive/Mudlet-${version}.tar.gz";
    sha256 = "08fhqd323kgz5s17ac5z9dhkjxcmwvcmvhzy0x1vw4rayhijfrd7";
  };

  nativeBuildInputs = [ makeWrapper qmake ];
  buildInputs = [
    unzip qtbase hunspell libzip yajl boost
    luaEnv
  ];

  preConfigure = "cd src";

  installPhase = ''
    mkdir -pv $out/bin
    cp mudlet $out
    cp -r mudlet-lua $out

    #
    makeWrapper $out/mudlet $out/bin/mudlet \
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
