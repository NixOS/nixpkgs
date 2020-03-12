{ stdenv, fetchFromGitHub, postgresql, zeromq, openssl }:

stdenv.mkDerivation rec {
  pname = "pipelinedb";
  version = "1.0.0-13";

  src = fetchFromGitHub {
    owner = "pipelinedb";
    repo = pname;
    rev = version;
    sha256 = "1mnqpvx6g1r2n4kjrrx01vbdx7kvndfsbmm7zbzizjnjlyixz75f";
  };

  buildInputs = [ postgresql openssl zeromq ];

  makeFlags = [ "USE_PGXS=1" ];

  preConfigure = ''
    substituteInPlace Makefile \
      --replace "/usr/lib/libzmq.a" "${zeromq}/lib/libzmq.a"
  '';

  installPhase = ''
    mkdir -p $out/bin
    install -D -t $out/lib/ pipelinedb.so
    install -D -t $out/share/postgresql/extension {pipelinedb-*.sql,pipelinedb.control}
  '';

  meta = with stdenv.lib; {
    description = "High-performance time-series aggregation for PostgreSQL";
    homepage = https://www.pipelinedb.com/;
    license = licenses.asl20;
    platforms = postgresql.meta.platforms;
    maintainers = [ maintainers.marsam ];
    broken = versionOlder postgresql.version "10";
  };
}
