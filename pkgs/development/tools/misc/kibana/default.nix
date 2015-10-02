{ stdenv, makeWrapper, fetchurl, nodejs, coreutils, which }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "kibana-${version}";
  version = "4.1.2";

  src = fetchurl {
    url = "http://download.elastic.co/kibana/kibana-snapshot/kibana-4.2.0-snapshot-linux-x86.tar.gz";
    sha256 = "1sa92laawxc05abiysvp12v5nzrqggmls592mkprwnbkkkbwsm5x";
  };

  buildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/libexec/kibana $out/bin
    mv * $out/libexec/kibana/
    rm -r $out/libexec/kibana/node
    makeWrapper $out/libexec/kibana/bin/kibana $out/bin/kibana \
      --prefix PATH : "${nodejs}/bin:${coreutils}/bin:${which}/bin"
  '';

  meta = {
    description = "Visualize logs and time-stamped data";
    homepage = http://www.elasticsearch.org/overview/kibana;
    license = licenses.asl20;
    maintainers = with maintainers; [ offline rickynils ];
  };
}
