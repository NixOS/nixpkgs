{ lib, stdenv
, fetchFromGitHub
, curl
, jansson
, perl
, autoreconfHook
}:

stdenv.mkDerivation rec {
  pname = "cpuminer";
  version = "2.5.1";

  src = fetchFromGitHub {
    owner = "pooler";
    repo = pname;
    rev = "v${version}";
    sha256 = "0f44i0z8rid20c2hiyp92xq0q0mjj537r05sa6vdbc0nl0a5q40i";
  };

  patchPhase = if stdenv.cc.isClang then "${perl}/bin/perl ./nomacro.pl" else null;

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ curl jansson ];

  configureFlags = [ "CFLAGS=-O3" ];

  meta = with lib; {
    homepage = "https://github.com/pooler/cpuminer";
    description = "CPU miner for Litecoin and Bitcoin";
    license = licenses.gpl2;
    platforms = platforms.all;
    maintainers = with maintainers; [ pSub ];
    # never built on aarch64-darwin since first introduction in nixpkgs
    broken = stdenv.isDarwin && stdenv.isAarch64;
  };
}
