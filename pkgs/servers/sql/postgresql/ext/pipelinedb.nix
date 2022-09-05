{ lib, stdenv, fetchFromGitHub, postgresql, zeromq, openssl, libsodium, libkrb5 }:

stdenv.mkDerivation rec {
  pname = "pipelinedb";
  version = "1.0.0-13";

  src = fetchFromGitHub {
    owner = "pipelinedb";
    repo = pname;
    rev = version;
    sha256 = "1mnqpvx6g1r2n4kjrrx01vbdx7kvndfsbmm7zbzizjnjlyixz75f";
  };

  buildInputs = [ postgresql openssl zeromq libsodium libkrb5 ];

  makeFlags = [ "USE_PGXS=1" ];

  NIX_LDFLAGS = lib.optionalString stdenv.isDarwin "-lsodium";

  preConfigure = ''
    substituteInPlace Makefile \
      --replace "/usr/lib/libzmq.a" "${zeromq}/lib/libzmq.a"
  '';

  installPhase = ''
    mkdir -p $out/bin
    install -D -t $out/lib/ pipelinedb.so
    install -D -t $out/share/postgresql/extension {pipelinedb-*.sql,pipelinedb.control}
  '';

  meta = with lib; {
    description = "High-performance time-series aggregation for PostgreSQL";
    homepage = "https://www.pipelinedb.com/";
    license = licenses.asl20;
    platforms = postgresql.meta.platforms;
    maintainers = [ maintainers.marsam ];
    broken = versions.major postgresql.version != "11";
  };
}
