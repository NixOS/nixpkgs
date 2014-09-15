{ stdenv, fetchurl, unzip, conf ? null }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "kibana-${version}";
  version = "3.1.0";

  src = fetchurl {
    url = "https://download.elasticsearch.org/kibana/kibana/${name}.zip";
    sha256 = "05i97zi08rxwx951hgs92fbhk6cchpvdlikrfz07v1dpn787xz8j";
  };

  buildInputs = [ unzip ];

  phases = ["unpackPhase" "installPhase"];
  installPhase = ''
    mkdir -p $out && cp -R * $out
    ${optionalString (conf!=null) ''cp ${conf} $out/config.js''}
  '';

  meta = {
    description = "Visualize logs and time-stamped data";
    homepage = http://www.elasticsearch.org/overview/kibana;
    license = licenses.asl20;

    maintainers = [ maintainers.offline ];
  };
}
