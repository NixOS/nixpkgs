{ stdenv, makeWrapper, fetchurl, nodejs, coreutils, which }:

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
    "x86_64-linux"  = "1wnnrhhpgc58s09p99cmi8r2jmwsd5lmh2inb0k8nmizz5v1sjz0";
    "i686-linux"    = "0sdx59jlfrf7r9793xpn2vxaxjdczgn3qfw8yny03dcs6fjaxi2y";
    "x86_64-darwin" = "0rmp536kn001g52lxngpj6x6d0j3qj0r11d4djbz7h6s5ml03kza";
  };
in stdenv.mkDerivation rec {
  name = "kibana-${version}";
  version = "4.6.5";

  src = fetchurl {
    url = "https://download.elastic.co/kibana/kibana/${name}-${plat}-${elasticArch}.tar.gz";
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
