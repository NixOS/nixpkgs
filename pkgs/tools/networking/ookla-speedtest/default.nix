{ lib, stdenv, fetchurl }:

let
  pname = "ookla-speedtest";
  version = "1.1.1";

  srcs = rec {
    x86_64-linux = fetchurl {
      url = "https://install.speedtest.net/app/cli/${pname}-${version}-linux-x86_64.tgz";
      sha256 = "sha256-lwR3/f7k10HnXwiPr2SPm1HHvgQxP7iP+13gfrGjBAw=";
    };
    aarch64-linux = fetchurl {
      url = "https://install.speedtest.net/app/cli/${pname}-${version}-linux-aarch64.tgz";
      sha256 = "sha256-J2pAhz/hw8okohWAwvxkqpLtNY/8bbYHGhPQOo1DH9k=";
    };
    x86_64-darwin = fetchurl {
      url = "https://install.speedtest.net/app/cli/${pname}-${version}.84-macosx-x86_64.tgz";
      sha256 = "sha256-FT925OUCortHDH98O0uK+qUOuYuxHoYhb8sai5JnbpQ=";
    };
    aarch64-darwin = x86_64-darwin;
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
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = with maintainers; [ kranzes ];
    platforms = lib.attrNames srcs;
  };
}
