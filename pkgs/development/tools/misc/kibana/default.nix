{ elk6Version
, enableUnfree ? true
, stdenv
, makeWrapper
, fetchzip
, fetchurl
, nodejs
, coreutils
, which
}:

with stdenv.lib;
let
  inherit (builtins) elemAt;
  info = splitString "-" stdenv.hostPlatform.system;
  arch = elemAt info 0;
  plat = elemAt info 1;
  shas =
    if enableUnfree
    then {
      "x86_64-linux"  = "0lip4bj3jazv83gydw99dnp03cb0fd1p4z3lvpjbisgmqffbbg5v";
      "x86_64-darwin" = "0hjdnqagcwbjhpcfyr6w0zmy4sjnx4fyp79czb0vp7dig5arnwm3";
    }
    else {
      "x86_64-linux"  = "1jybn4q7pz61iijzl85d948szlacfcbldn2nhhsb6063xwvf30sa";
      "x86_64-darwin" = "1bl1h6hgp9l5cjq6pzj2x855wjaka8hbs0fn2c03lbzsc991dppr";
    };

  # For the correct phantomjs version see:
  # https://github.com/elastic/kibana/blob/master/x-pack/plugins/reporting/server/browsers/phantom/paths.js
  phantomjs = rec {
    name = "phantomjs-${version}-linux-x86_64";
    version = "2.1.1";
    src = fetchzip {
      inherit name;
      url = "https://github.com/Medium/phantomjs/releases/download/v${version}/${name}.tar.bz2";
      sha256 = "0g2dqjzr2daz6rkd6shj6rrlw55z4167vqh7bxadl8jl6jk7zbfv";
    };
  };

in stdenv.mkDerivation rec {
  name = "kibana-${optionalString (!enableUnfree) "oss-"}${version}";
  version = elk6Version;

  src = fetchurl {
    url = "https://artifacts.elastic.co/downloads/kibana/${name}-${plat}-${arch}.tar.gz";
    sha256 = shas."${stdenv.hostPlatform.system}" or (throw "Unknown architecture");
  };

  patches = [
    # Kibana specifies it specifically needs nodejs 8.11.4 but nodejs in nixpkgs is at 8.12.0.
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
  '' +
  # phantomjs is needed in the unfree version. When phantomjs doesn't exist in
  # $out/libexec/kibana/data kibana will try to download and unpack it during
  # runtime which will fail because the nix store is read-only. So we make sure
  # it already exist in the nix store.
  optionalString enableUnfree ''
    ln -s ${phantomjs.src} $out/libexec/kibana/data/${phantomjs.name}
  '';

  meta = {
    description = "Visualize logs and time-stamped data";
    homepage = http://www.elasticsearch.org/overview/kibana;
    license = if enableUnfree then licenses.elastic else licenses.asl20;
    maintainers = with maintainers; [ offline rickynils basvandijk ];
    platforms = with platforms; unix;
  };
}
