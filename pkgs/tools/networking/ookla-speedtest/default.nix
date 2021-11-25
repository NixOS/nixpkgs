{ lib, stdenv, fetchurl }:

let
  pname = "ookla-speedtest";
  version = "1.1.0";

  srcs = {
    x86_64-linux = fetchurl {
      url = "https://install.speedtest.net/app/cli/${pname}-${version}-x86_64-linux.tgz";
      sha256 = "sha256-/NWN8G6uqokjchSnNcC3FU1qDsOjt4Jh2kCnZc5B9H8=";
    };
    aarch64-linux = fetchurl {
      url = "https://install.speedtest.net/app/cli/${pname}-${version}-aarch64-linux.tgz";
      sha256 = "sha256-kyOrChC3S8kn4ArO5IylFIstS/N3pXxBVx4ZWI600oU=";
    };
  };
in

stdenv.mkDerivation rec {
  inherit pname version;

  src = srcs.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  setSourceRoot = ''
    sourceRoot=$PWD
  '';

  dontBuild = true;
  dontConfigure = true;

  installPhase = ''
    install -D speedtest $out/bin/speedtest
    install -D speedtest.5 $out/share/man/man5/speedtest.5
  '';

  meta = with lib; {
    description = "Command line internet speedtest tool by Ookla";
    homepage = "https://www.speedtest.net/apps/cli";
    license = licenses.unfree;
    maintainers = with maintainers; [ kranzes ];
    platforms = lib.attrNames srcs;
  };
}
