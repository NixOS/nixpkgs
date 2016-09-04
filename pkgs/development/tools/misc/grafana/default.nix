{ stdenv, fetchurl, unzip, conf ? null }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "grafana-${version}";
  version = "1.9.1";

  src = fetchurl {
    url = "http://grafanarel.s3.amazonaws.com/${name}.zip";
    sha256 = "1zyzsbspxrzaf2kk6fysp6c3y025s6nd75rc2p9qq9q95dv8fj23";
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
    platforms = stdenv.lib.platforms.unix;
  };
}
