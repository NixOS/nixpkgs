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
      "x86_64-linux"  = "1c56l3z2k9ncmx3kbam2hr2m4pkhxv0l226bla5vz0y6adh2zcs5";
      "x86_64-darwin" = "08hq8fjc93j25dpd8l61a2rfvpdgl0my75gg0pfqfaspknbdq2a1";
    }
    else {
      "x86_64-linux"  = "0jrjbg63nxnpc2cx8m6z6fw28mj1yq0dw1whbykaxdwzhjcf0v96";
      "x86_64-darwin" = "07fm15mpg7ljyjmz2dq16jwxhsml9hxdmnbb3qpcl9bidvjdlw4k";
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
