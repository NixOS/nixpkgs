{ stdenv, fetchurl, unzip, conf ? null }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "grafana-${version}";
  version = "1.8.0-rc1";

  src = fetchurl {
    url = "http://grafanarel.s3.amazonaws.com/${name}.zip";
    sha256 = "1wx4zwkpgvb8lxcrkp67zgqd8aqms4bnxzwz3i9190sl55j1yf4i";
  };

  buildInputs = [ unzip ];

  phases = ["unpackPhase" "installPhase"];
  installPhase = ''
    mkdir -p $out && cp -R * $out
    ${optionalString (conf!=null) ''cp ${conf} $out/config.js''}
  '';

  meta = {
    description = "A Graphite & InfluxDB Dashboard and Graph Editor";
    homepage = http://grafana.org/;
    license = licenses.asl20;

    maintainers = [ maintainers.offline ];
  };
}
