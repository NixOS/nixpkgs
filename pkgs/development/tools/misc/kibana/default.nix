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
    "x86_64-linux"  = "1md3y3a8rxvf37lnfc56kbirv2rjl68pa5672yxhfmjngrr20rcw";
    "i686-linux"    = "0d77a2v14pg5vr711hzbva8jjy0sxw9w889f2r1vhwngrhcfz4pf";
    "x86_64-darwin" = "1cajljx13h8bncmayzvlzsynwambz61cspjnsn2h19zghn2vj2c9";
  };
in stdenv.mkDerivation rec {
  name = "kibana-${version}";
  version = "4.6.0";

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
