{ stdenv, makeWrapper, fetchurl, elk5Version, nodejs, coreutils, which }:

with stdenv.lib;
let
  inherit (builtins) elemAt;
  archOverrides = {
    "i686" = "x86";
  };
  info = splitString "-" stdenv.hostPlatform.system;
  arch = (elemAt info 0);
  elasticArch = archOverrides."${arch}" or arch;
  plat = elemAt info 1;
  shas = {
    "x86_64-linux"  = "1rg4j5jm8mkscrwlbx5qk3qjnblyr8z9x5npvyi73zm0ism0gv4j";
    "i686-linux"    = "14swgx9sf23pns2pj30yyhd0p0rnykdimdrnj8rb0r1pqszw57qx";
    "x86_64-darwin" = "10l13r47nx74xicnjgb56nvgvx2al1zx1p8f09pjldaa2gjlll2k";
  };
in stdenv.mkDerivation rec {
  name = "kibana-${version}";
  version = elk5Version;

  src = fetchurl {
    url = "https://artifacts.elastic.co/downloads/kibana/${name}-${plat}-${elasticArch}.tar.gz";
    sha256 = shas."${stdenv.hostPlatform.system}" or (throw "Unknown architecture");
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
