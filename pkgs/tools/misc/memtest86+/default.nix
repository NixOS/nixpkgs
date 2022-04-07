{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "memtest86+";
  # FIXME: wait for stable release
  version = "6.00-beta2";

  src = fetchFromGitHub {
    owner = "memtest86plus";
    repo = "memtest86plus";
    rev = "v${version}";
    sha256 = "sha256-U3++iJa0Zj3g2SZTJ0jom7raAu+LGqiOKZEputs/YfM=";
  };

  buildPhase = let
    bits = if stdenv.is32bit then "32"
           else if stdenv.is64bit then "64"
           else throw "unsupported system!";
  in ''
    cd build${bits}
    make memtest.bin memtest.efi
  '';

  installPhase = ''
    install -Dm0444 -t $out/ memtest.bin memtest.efi
  '';

  meta = {
    homepage = "http://www.memtest.org/";
    description = "A tool to detect memory errors";
    license = lib.licenses.gpl2;
    platforms = [ "x86_64-linux" "i686-linux" ];
  };
}
