{ elk7Version
, enableUnfree ? true
, lib
, stdenv
, makeWrapper
, fetchurl
, nodejs-16_x
, coreutils
, which
}:

with lib;
let
  nodejs = nodejs-16_x;
  inherit (builtins) elemAt;
  info = splitString "-" stdenv.hostPlatform.system;
  arch = elemAt info 0;
  plat = elemAt info 1;
  shas =
    {
      x86_64-linux  = "b657d82c8189acc8a8f656ab949e1484aaa98755a16c33f48c318fb17180343f";
      x86_64-darwin = "ac2b5a639ad83431db25e4161f811111d45db052eb845091e18f847016a34a55";
      aarch64-linux = "a1f7ab9e874799bf380b94394e5bb1ce28f38019896293dde8797d74ad273e67";
    };

in stdenv.mkDerivation rec {
  pname = "kibana";
  version = elk7Version;

  src = fetchurl {
    url = "https://artifacts.elastic.co/downloads/kibana/${pname}-${version}-${plat}-${arch}.tar.gz";
    sha256 = shas.${stdenv.hostPlatform.system} or (throw "Unknown architecture");
  };

  patches = [
    # Kibana specifies it specifically needs nodejs 10.15.2 but nodejs in nixpkgs is at 10.15.3.
    # The <nixpkgs/nixos/tests/elk.nix> test succeeds with this newer version so lets just
    # disable the version check.
    ./disable-nodejs-version-check-7.patch
  ];

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/libexec/kibana $out/bin
    mv * $out/libexec/kibana/
    rm -r $out/libexec/kibana/node
    makeWrapper $out/libexec/kibana/bin/kibana $out/bin/kibana \
      --prefix PATH : "${lib.makeBinPath [ nodejs coreutils which ]}"
    sed -i 's@NODE=.*@NODE=${nodejs}/bin/node@' $out/libexec/kibana/bin/kibana
  '';

  meta = {
    description = "Visualize logs and time-stamped data";
    homepage = "http://www.elasticsearch.org/overview/kibana";
    license = licenses.elastic;
    maintainers = with maintainers; [ offline basvandijk ];
    platforms = with platforms; unix;
  };
}
