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
    "x86_64-linux"  = "1g5i81wq77fk6pyaq3rpfqs2m23xsbz2cndh3rg4b59ibg5qv0sq";
    "i686-linux"    = "0pxnpg3g8l6hy8qz404kbkk5rd9y65jrzd0y9j8wr5fd4pqs7vgv";
    "x86_64-darwin" = "0pffl2hbck3s271jlzdibp5698djm5fdvj15w2knm815rs2kfbl5";
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
