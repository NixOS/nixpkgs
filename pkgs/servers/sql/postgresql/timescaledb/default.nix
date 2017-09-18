{ stdenv, fetchFromGitHub, postgresql }:

stdenv.mkDerivation rec {
  name = "timescaledb-${version}";
  version = "0.4.2";

  buildInputs = [ postgresql ];

  src = fetchFromGitHub {
    owner = "timescale";
    repo = "timescaledb";
    rev = version;
    sha256 = "0rwcd7wg3kv343b02330nlpqfm6jj5g0d2pkr1pc78cq8prhxx39";
  };

  installPhase = ''
    mkdir -p $out/bin
    install -D timescaledb.so                  -t $out/lib
    install -D timescaledb.control             -t $out/share/extension
    install -D sql/timescaledb--${version}.sql -t $out/share/extension
  '';

  meta = with stdenv.lib; {
    description = "TimescaleDB scales PostgreSQL for time-series data via automatic partitioning across time and space";
    homepage = https://www.timescale.com/;
    maintainers = with maintainers; [ volth ];
    platforms = platforms.linux;
    license = licenses.postgresql;
  };
}
