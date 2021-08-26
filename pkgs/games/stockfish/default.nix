{ lib, stdenv, fetchurl, fetchFromGitHub }:

let
    # The x86-64-modern may need to be refined further in the future
    # but stdenv.hostPlatform CPU flags do not currently work on Darwin
    # https://discourse.nixos.org/t/darwin-system-and-stdenv-hostplatform-features/9745
    archDarwin = if stdenv.isx86_64 then "x86-64-modern" else "x86-64";
    arch = if stdenv.isDarwin then archDarwin else
           if stdenv.isx86_64 then "x86-64" else
           if stdenv.isi686 then "x86-32" else
           if stdenv.isAarch64 then "armv8" else
           "unknown";

    nnueFile = "nn-3475407dc199.nnue";
    nnue = fetchurl {
      name = nnueFile;
      url = "https://tests.stockfishchess.org/api/nn/${nnueFile}";
      sha256 = "sha256-NHVAfcGZc+pERnZ4Y0zOAj1iDkGXcMERzIk3/maJ7Ic=";
    };
in

stdenv.mkDerivation rec {
  pname = "stockfish";
  version = "14";

  src = fetchFromGitHub {
    owner = "official-stockfish";
    repo = "Stockfish";
    rev = "sf_${version}";
    sha256 = "sha256-fX0Tr1yqjmNRSxmisFRKUY1E5//qF3zAfJ8innAeyxA=";
  };

  # This addresses a linker issue with Darwin
  # https://github.com/NixOS/nixpkgs/issues/19098
  preBuild = lib.optionalString stdenv.isDarwin ''
    sed -i.orig '/^\#\#\# 3.*Link Time Optimization/,/^\#\#\# 3/d' Makefile
  '';

  postUnpack = ''
    sourceRoot+=/src
    echo ${nnue}
    cp "${nnue}" "$sourceRoot/${nnueFile}"
  '';

  makeFlags = [ "PREFIX=$(out)" "ARCH=${arch}" "CXX=${stdenv.cc.targetPrefix}c++" ];
  buildFlags = [ "build" ];

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://stockfishchess.org/";
    description = "Strong open source chess engine";
    longDescription = ''
      Stockfish is one of the strongest chess engines in the world. It is also
      much stronger than the best human chess grandmasters.
      '';
    maintainers = with maintainers; [ luispedro peti siraben ];
    platforms = ["x86_64-linux" "i686-linux" "x86_64-darwin" "aarch64-linux"];
    license = licenses.gpl2;
  };

}
