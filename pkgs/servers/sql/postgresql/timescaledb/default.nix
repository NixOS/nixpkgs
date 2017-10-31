{ stdenv, fetchFromGitHub, postgresql }:

# # To enable on NixOS:
# config.services.postgresql = {
#   extraPlugins = [ pkgs.timescaledb ];
#   extraConfig = "shared_preload_libraries = 'timescaledb'";
# }

stdenv.mkDerivation rec {
  name = "timescaledb-${version}";
  version = "0.5.0";

  buildInputs = [ postgresql ];

  src = fetchFromGitHub {
    owner = "timescale";
    repo = "timescaledb";
    rev = version;
    sha256 = "01swgjw563c42azxsg55ry7cyiipxkcvfrxmw71jil5dxl3s0fkz";
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
