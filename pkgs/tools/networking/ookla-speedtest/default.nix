{ lib, stdenv, fetchurl }:

let
  pname = "ookla-speedtest";
  version = "1.0.0";

  srcs = {
    x86_64-linux = fetchurl {
      url = "https://install.speedtest.net/app/cli/${pname}-${version}-x86_64-linux.tgz";
      sha256 = "sha256-X+ICjw1EJ+T0Ix2fnPcOZpG7iQpwY211Iy/k2XBjMWg=";
    };
    aarch64-linux = fetchurl {
      url = "https://install.speedtest.net/app/cli/${pname}-${version}-aarch64-linux.tgz";
      sha256 = "sha256-BzaE3DSQUIygGwTFhV4Ez9eX/tM/bqam7cJt+8b2qp4=";
    };
  };
in

stdenv.mkDerivation rec {
  inherit pname version;

  src = srcs.${stdenv.hostPlatform.system};

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
