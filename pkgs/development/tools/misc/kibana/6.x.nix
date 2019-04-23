{ elk6Version
, enableUnfree ? true
, stdenv
, makeWrapper
, fetchzip
, fetchurl
, nodejs-10_x
, coreutils
, which
}:

with stdenv.lib;
let
  nodejs = nodejs-10_x;
  inherit (builtins) elemAt;
  info = splitString "-" stdenv.hostPlatform.system;
  arch = elemAt info 0;
  plat = elemAt info 1;
  shas =
    if enableUnfree
    then {
      "x86_64-linux"  = "039ll00kvrp881cyybb04z90cw68j7p5cspgdxh0bky9lyi9qpwb";
      "x86_64-darwin" = "0qrakrihcjwn9dic77b0k9ja3zf6nbz534v76xid9gv20md5dds3";
    }
    else {
      "x86_64-linux"  = "1v1fbmfkbnlx043z3yx02gaqqy63bj2ymvcby66n4qq0vlpahvwx";
      "x86_64-darwin" = "1y4q7a2b9arln94d6sj547qkv3258jlgcz9b342fh6khlbpfjb8c";
    };

in stdenv.mkDerivation rec {
  name = "kibana-${optionalString (!enableUnfree) "oss-"}${version}";
  version = elk6Version;

  src = fetchurl {
    url = "https://artifacts.elastic.co/downloads/kibana/${name}-${plat}-${arch}.tar.gz";
    sha256 = shas."${stdenv.hostPlatform.system}" or (throw "Unknown architecture");
  };

  patches = [
    # Kibana specifies it specifically needs nodejs 10.15.2 but nodejs in nixpkgs is at 10.15.3.
    # The <nixpkgs/nixos/tests/elk.nix> test succeeds with this newer version so lets just
    # disable the version check.
    ./disable-nodejs-version-check.patch
  ];

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
    license = if enableUnfree then licenses.elastic else licenses.asl20;
    maintainers = with maintainers; [ offline rickynils basvandijk ];
    platforms = with platforms; unix;
  };
}
