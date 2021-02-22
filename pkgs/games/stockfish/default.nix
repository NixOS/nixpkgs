{ lib, stdenv, fetchurl }:

with lib;

let
    # The x86-64-modern may need to be refined further in the future
    # but stdenv.hostPlatform CPU flags do not currently work on Darwin
    # https://discourse.nixos.org/t/darwin-system-and-stdenv-hostplatform-features/9745
    archDarwin = if stdenv.isx86_64 then "x86-64-modern" else "x86-64";
    arch = if stdenv.isDarwin then archDarwin else
           if stdenv.isx86_64 then "x86-64" else
           if stdenv.isi686 then "x86-32" else
           "unknown";
    version = "12";

    nnueFile = "nn-82215d0fd0df.nnue";
    nnue = fetchurl {
      name = nnueFile;
      url = "https://tests.stockfishchess.org/api/nn/${nnueFile}";
      sha256 = "1r4yqrh4di05syyhl84hqcz84djpbd605b27zhbxwg6zs07ms8c2";
    };
in

stdenv.mkDerivation {
  pname = "stockfish";
  inherit version;

  src = fetchurl {
    url = "https://github.com/official-stockfish/Stockfish/archive/sf_${version}.tar.gz";
    sha256 = "16980aicm5i6i9252239q4f9bcxg1gnqkv6nphrmpz4drg8i3v6i";
  };

  # This addresses a linker issue with Darwin
  # https://github.com/NixOS/nixpkgs/issues/19098
  preBuild = optionalString stdenv.isDarwin ''
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

  meta = {
    homepage = "https://stockfishchess.org/";
    description = "Strong open source chess engine";
    longDescription = ''
      Stockfish is one of the strongest chess engines in the world. It is also
      much stronger than the best human chess grandmasters.
      '';
    maintainers = with maintainers; [ luispedro peti ];
    platforms = ["x86_64-linux" "i686-linux" "x86_64-darwin"];
    license = licenses.gpl2;
  };

}
