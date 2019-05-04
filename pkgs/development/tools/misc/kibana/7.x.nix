{ elk7Version
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
      "x86_64-linux"  = "0awkbnbrffv2m6n9zqv8k4m23g4mril69rmj84ndqpdnv7shrk4l";
      "x86_64-darwin" = "0mbaya0xq99vfl8bn1wgi4m43c8qjp910bxf26z436km64311pip";
    }
    else {
      "x86_64-linux"  = "0fy8vh0x2p8n2r3n5f67h1r5z75qfx5q4fghgqwnqymray5798v4";
      "x86_64-darwin" = "0zyhvbwvdj95v2nswx5b83n4cw3zy5a6bkrvypw6k1i833c6v5g7";
    };

in stdenv.mkDerivation rec {
  name = "kibana-${optionalString (!enableUnfree) "oss-"}${version}";
  version = elk7Version;

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
