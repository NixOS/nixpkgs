{ elk6Version
, enableUnfree ? true
, lib, stdenv
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
      x86_64-linux  = "1a501lavxhckb3l93sbrbqyshicwkk6p89frry4x8p037xcfpy0x";
      x86_64-darwin = "0zm45af30shhcg3mdhcma6rms1hyrx62rm5jzwnz9kxv4d30skbw";
    }
    else {
      x86_64-linux  = "0wfdipf21apyily7mvlqgyc7m5jpr96zgrryzwa854z3xb2vw8zg";
      x86_64-darwin = "1nklfx4yz6hsxlljvnvwjy7pncv9mzngl84710xad5jlyras3sdj";
    };

in stdenv.mkDerivation rec {
  pname = "kibana${optionalString (!enableUnfree) "-oss"}";
  version = elk6Version;

  src = fetchurl {
    url = "https://artifacts.elastic.co/downloads/kibana/${pname}-${version}-${plat}-${arch}.tar.gz";
    sha256 = shas.${stdenv.hostPlatform.system} or (throw "Unknown architecture");
  };

  patches = [
    # Kibana specifies it specifically needs nodejs 10.15.2 but nodejs in nixpkgs is at 10.15.3.
    # The <nixpkgs/nixos/tests/elk.nix> test succeeds with this newer version so lets just
    # disable the version check.
    ./disable-nodejs-version-check.patch
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
