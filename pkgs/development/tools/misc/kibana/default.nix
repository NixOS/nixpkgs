{ stdenv, fetchurl, conf ? null }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "kibana-${version}";
  version = "3.1.1";

  src = fetchurl {
    url = "https://download.elasticsearch.org/kibana/kibana/${name}.tar.gz";
    sha256 = "195x6zq9x16nlh2akvn6z0kp8qnba4vq90yrysiafgv8dmw34p5b";
  };

  phases = ["unpackPhase" "installPhase"];

  installPhase = ''
    mkdir -p $out
    mv * $out/
    ${optionalString (conf != null) "cp ${conf} $out/config.js"}
  '';

  meta = {
    description = "Visualize logs and time-stamped data";
    homepage = http://www.elasticsearch.org/overview/kibana;
    license = licenses.asl20;
    maintainers = with maintainers; [ offline rickynils ];
  };
}
