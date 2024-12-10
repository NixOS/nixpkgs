{
  lib,
  stdenv,
  fetchurl,
  fetchFromGitHub,
}:

let
  # The x86-64-modern may need to be refined further in the future
  # but stdenv.hostPlatform CPU flags do not currently work on Darwin
  # https://discourse.nixos.org/t/darwin-system-and-stdenv-hostplatform-features/9745
  archDarwin = if stdenv.isx86_64 then "x86-64-modern" else "apple-silicon";
  arch =
    if stdenv.isDarwin then
      archDarwin
    else if stdenv.isx86_64 then
      "x86-64"
    else if stdenv.isi686 then
      "x86-32"
    else if stdenv.isAarch64 then
      "armv8"
    else
      "unknown";

  nnueFile = "nn-5af11540bbfe.nnue";
  nnue = fetchurl {
    name = nnueFile;
    url = "https://tests.stockfishchess.org/api/nn/${nnueFile}";
    sha256 = "sha256-WvEVQLv+/LVOOMXdAAyrS0ad+nWZodVb5dJyLCCokps=";
  };
in

stdenv.mkDerivation rec {
  pname = "stockfish";
  version = "16";

  src = fetchFromGitHub {
    owner = "official-stockfish";
    repo = "Stockfish";
    rev = "sf_${version}";
    sha256 = "sha256-ASy2vIP94lnSKgxixK1GoC84yAysaJpxeyuggV4MrP4=";
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

  makeFlags = [
    "PREFIX=$(out)"
    "ARCH=${arch}"
    "CXX=${stdenv.cc.targetPrefix}c++"
  ];
  buildFlags = [ "build" ];

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://stockfishchess.org/";
    description = "Strong open source chess engine";
    mainProgram = "stockfish";
    longDescription = ''
      Stockfish is one of the strongest chess engines in the world. It is also
      much stronger than the best human chess grandmasters.
    '';
    maintainers = with maintainers; [
      luispedro
      siraben
    ];
    platforms = [
      "x86_64-linux"
      "i686-linux"
      "x86_64-darwin"
      "aarch64-linux"
      "aarch64-darwin"
    ];
    license = licenses.gpl3Only;
  };

}
