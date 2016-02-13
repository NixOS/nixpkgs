{ stdenv, makeWrapper, fetchurl, nodejs, coreutils, which }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "kibana-${version}";
  version = "4.1.2";

  src = fetchurl {
    url = "http://download.elastic.co/kibana/kibana-snapshot/${name}-snapshot-linux-x86.tar.gz";
    sha256 = "00ag4wnlw6h2j6zcz0irz6j1s51fr9ix2g1smrhrdw44z5gb6wrh";
  };

  buildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/libexec/kibana $out/bin
    mv * $out/libexec/kibana/
    rm -r $out/libexec/kibana/node
    makeWrapper $out/libexec/kibana/bin/kibana $out/bin/kibana \
      --prefix PATH : "${nodejs}/bin:${coreutils}/bin:${which}/bin"
    sed -i 's@NODE=.*@NODE=${nodejs}/bin/node@' $out/libexec/kibana/bin/kibana
  '';

  meta = {
    description = "Visualize logs and time-stamped data";
    homepage = http://www.elasticsearch.org/overview/kibana;
    license = licenses.asl20;
    maintainers = with maintainers; [ offline rickynils ];
  };
}
