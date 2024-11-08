{ lib, stdenvNoCC, fetchurl }:

let
  stdenv = stdenvNoCC;

  pname = "ookla-speedtest";
  version = "1.2.0";

  srcs = rec {
    x86_64-linux = fetchurl {
      url = "https://install.speedtest.net/app/cli/${pname}-${version}-linux-x86_64.tgz";
      sha256 = "sha256-VpBZbFT/m+1j+jcy+BigXbwtsZrTbtaPIcpfZNXP7rc=";
    };
    i686-linux = fetchurl {
      url = "https://install.speedtest.net/app/cli/${pname}-${version}-linux-i386.tgz";
      sha256 = "sha256-n/fhjbrn7g4DxmEIRFovts7qbIb2ZILhOS9ViBt3L+g=";
    };
    aarch64-linux = fetchurl {
      url = "https://install.speedtest.net/app/cli/${pname}-${version}-linux-aarch64.tgz";
      sha256 = "sha256-OVPSMdo3g+K/iQS23XJ2fFxuUz4WPTdC/QQ3r/pDG9M=";
    };
    armv7l-linux = fetchurl {
      url = "https://install.speedtest.net/app/cli/${pname}-${version}-linux-armhf.tgz";
      sha256 = "sha256-5F/N672KGFVTU1Uz3QMtaxC8jGTu5BObEUe5wJg10I0=";
    };
    x86_64-darwin = fetchurl {
      url = "https://install.speedtest.net/app/cli/${pname}-${version}-macosx-universal.tgz";
      sha256 = "sha256-yfgZIUnryI+GmZmM7Ksc4UQUQEWQfs5vU89Qh39N5m8=";
    };
    aarch64-darwin = x86_64-darwin;
  };
in

stdenv.mkDerivation rec {
  inherit pname version;

  src = srcs.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  sourceRoot = ".";

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
    mainProgram = "speedtest";
  };
}
