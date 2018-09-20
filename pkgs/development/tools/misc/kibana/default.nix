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
      "x86_64-linux"  = "11mzi6wfpg880z53nbd8kn892rf70xyn4shnjxmvj1fba1sa8vvc";
      "x86_64-darwin" = "16ws86vnr0i701djaxq4k5f2wax0c0xji4i77vgs106hcg99qclr";
    }
    else {
      "x86_64-linux"  = "0m3z5ibl82039wicmv6xs5has8ccrqv7gffy7disggflcqq2clk2";
      "x86_64-darwin" = "09cc9s19kfl7ff8havhhs0qby0b5sp2agvh9mik5j9qn42whjsjm";
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
