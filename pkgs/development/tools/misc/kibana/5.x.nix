{ stdenv, makeWrapper, fetchurl, elk5Version, nodejs, coreutils, which }:

with stdenv.lib;
let
  inherit (builtins) elemAt;
  archOverrides = {
    "i686" = "x86";
  };
  info = splitString "-" stdenv.system;
  arch = (elemAt info 0);
  elasticArch = archOverrides."${arch}" or arch;
  plat = elemAt info 1;
  shas = {
    "x86_64-linux"  = "0nmx7r6i54x7pii4ryh3wzzbwvnmcb3f1hn6ch96r24xi4v9m1sb";
    "i686-linux"    = "0am6wmbcsh7zxzdrl1q9jbjrb7y4apvi6sr70j61xcx07pbickpp";
    "x86_64-darwin" = "0kjnlzsz4i2fca3jgfsr1kknqzaypb0r78a7cxz2m7daj3bmpvpl";
  };
in stdenv.mkDerivation rec {
  name = "kibana-${version}";
  version = elk5Version;

  src = fetchurl {
    url = "https://artifacts.elastic.co/downloads/kibana/${name}-${plat}-${elasticArch}.tar.gz";
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
    maintainers = with maintainers; [ offline rickynils ];
    platforms = with platforms; unix;
  };
}
