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
      "x86_64-linux"  = "1i3zmzxihplwd8n994lfxhhgygdg3qxjqgrj1difa8w3vss0zbfn";
      "x86_64-darwin" = "09a96ms9id77infxd9xxfs6r7j01mn0rz5yw3g9sl92j9ri7r52c";
    }
    else {
      "x86_64-linux"  = "166rhxr0qlv1yarj2mg1c3b8mxvhl70jhz53azq7ic6laj55q7fk";
      "x86_64-darwin" = "0ngngkbl036p2mzwhp8qafi3aqzk398a218w12srfqny5n630vdk";
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
