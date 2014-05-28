{ stdenv, fetchurl, unzip, conf ? null }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "grafana-${version}";
  version = "1.5.4";

  src = fetchurl {
    url = "http://grafanarel.s3.amazonaws.com/${name}.zip";
    sha256 = "fee7334efba967142955be2fa39ecae7bca0cc9b7a76c301430746be4fc7ec6d";
  };

  buildInputs = [ unzip ];

  phases = ["unpackPhase" "installPhase"];
  installPhase = ''
    ensureDir $out && cp -R * $out
    ${optionalString (conf!=null) ''cp ${conf} $out/config.js''}
  '';

  meta = {
    description = "A Graphite & InfluxDB Dashboard and Graph Editor";
    homepage = http://grafana.org/;
    license = licenses.asl20;

    maintainers = [ maintainers.offline ];
  };
}
