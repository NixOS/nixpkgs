{ stdenv, fetchFromGitHub, postgresql }:

# # To enable on NixOS:
# config.services.postgresql = {
#   extraPlugins = [ pkgs.timescaledb ];
#   extraConfig = "shared_preload_libraries = 'timescaledb'";
# }

stdenv.mkDerivation rec {
  name = "timescaledb-${version}";
  version = "0.6.0";

  buildInputs = [ postgresql ];

  src = fetchFromGitHub {
    owner = "timescale";
    repo = "timescaledb";
    rev = version;
    sha256 = "061z1ll3x7ca7fj12rl2difkdvmqykksqhpsql552qkkylg7iq4d";
  };

  installPhase = ''
    mkdir -p $out/bin
    install -D timescaledb.so      -t $out/lib
    install -D timescaledb.control -t $out/share/extension
    cp -dpR    sql/*                  $out/share/extension/
  '';

  meta = with stdenv.lib; {
    description = "Scales PostgreSQL for time-series data via automatic partitioning across time and space";
    homepage = https://www.timescale.com/;
    maintainers = with maintainers; [ volth ];
    platforms = platforms.linux;
    license = licenses.postgresql;
  };
}
