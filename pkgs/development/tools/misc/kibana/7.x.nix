{ elk7Version
, enableUnfree ? true
, lib
, stdenv
, makeWrapper
, fetchurl
, nodejs-10_x
, coreutils
, which
}:

with lib;
let
  nodejs = nodejs-10_x;
  inherit (builtins) elemAt;
  info = splitString "-" stdenv.hostPlatform.system;
  arch = elemAt info 0;
  plat = elemAt info 1;
  shas =
    if enableUnfree
    then {
      x86_64-linux = "sha256-lTPBppKm51zgKSQtSdO0PgZ/aomvaStwqwYYGNPY4Bo=";
      x86_64-darwin = "sha256-d7xHmoASiywDlZCJX/CfUX1VIi4iOcDrqvK0su54MJc=";
    }
    else {
      x86_64-linux = "sha256-+pkKpiXBpLHs72KKNtMJbqipw6eu5XC1xu/iLFCHGRQ=";
      x86_64-darwin = "sha256-CyJ5iRXaPgXO2lyy+E24OcGtb9V3e1gMZRIu25bVyzk=";
    };

in
stdenv.mkDerivation rec {
  pname = "kibana${optionalString (!enableUnfree) "-oss"}";
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
    license = if enableUnfree then licenses.elastic else licenses.asl20;
    maintainers = with maintainers; [ offline basvandijk ];
    platforms = with platforms; unix;
  };
}
