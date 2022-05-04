{ lib, stdenv, fetchFromGitHub, libpng, rlottie, zlib }:

stdenv.mkDerivation rec {
  pname = "LottieConverter";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "sot-tech";
    repo = pname;
    rev = "r${version}";
    hash = "sha256-lAGzh6B2js2zDuN+1U8CZnse09RJGZRXbtmsheGKuYU=";
  };

  buildInputs = [ libpng rlottie zlib ];
  makeFlags = [ "CONF=Release" ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp -v dist/Release/GNU-Linux/lottieconverter $out/bin/

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/sot-tech/LottieConverter/";
    description = "Lottie converter utility";
    license = licenses.lgpl21Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ CRTified ];
    broken = stdenv.isDarwin; # never built on Hydra https://hydra.nixos.org/job/nixpkgs/trunk/lottieconverter.x86_64-darwin
  };
}
