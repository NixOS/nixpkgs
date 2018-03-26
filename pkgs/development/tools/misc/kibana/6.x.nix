{ stdenv, makeWrapper, fetchurl, elk6Version, nodejs, coreutils, which }:

with stdenv.lib;
let
  inherit (builtins) elemAt;
  info = splitString "-" stdenv.system;
  arch = elemAt info 0;
  plat = elemAt info 1;
  shas = {
    "x86_64-linux"  = "15iykvbqgqj9lk764rkl52f47b6v59kvfiqfvdp3n3anszyqcc5d";
    "x86_64-darwin" = "04fgazl5rzb4vw8xn5s46w44f2rdpki81q2rch2jiq9hf8bqm55m";
  };
in stdenv.mkDerivation rec {
  name = "kibana-${version}";
  version = elk6Version;

  src = fetchurl {
    url = "https://artifacts.elastic.co/downloads/kibana/${name}-${plat}-${arch}.tar.gz";
    sha256 = shas."${stdenv.system}" or (throw "Unknown architecture");
  };

  buildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/libexec/kibana $out/bin
    mv * $out/libexec/kibana/
    rm -r $out/libexec/kibana/node
    makeWrapper $out/libexec/kibana/bin/kibana $out/bin/kibana \
      --prefix PATH : "${stdenv.lib.makeBinPath [ nodejs coreutils which ]}"
    sed -i 's@NODE=.*@NODE=${nodejs}/bin/node@' $out/libexec/kibana/bin/kibana
  '';

  meta = {
    description = "Visualize logs and time-stamped data";
    homepage = http://www.elasticsearch.org/overview/kibana;
    license = licenses.asl20;
    maintainers = with maintainers; [ offline rickynils basvandijk ];
    platforms = with platforms; unix;
  };
}
