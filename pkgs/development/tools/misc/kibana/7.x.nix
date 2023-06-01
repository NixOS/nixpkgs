{ elk7Version
, enableUnfree ? true
, lib
, stdenv
, makeWrapper
, fetchurl
, nodejs_16
, coreutils
, which
}:

let
  nodejs = nodejs_16;
  inherit (builtins) elemAt;
  info = lib.splitString "-" stdenv.hostPlatform.system;
  arch = elemAt info 0;
  plat = elemAt info 1;
  shas =
    {
      x86_64-linux  = "d3d5e8906e64ae3c469e4df80e1c692ce1912e36f68ddf36b99b7019faf34aebaa329061904a6d2b6a32486c6e19d1c5f2ea30c25479a7960ed93bc1c0cb1691";
      x86_64-darwin = "72a4499efbbbdf425f92beafc1b1d416e66e6ded60e76d9c9af9c3c13ce11862ba54dffbfbd5cbdef6afaad50f0d57532d3524f83acd88840aecc6891f748732";
      aarch64-linux = "ce1b584e1cf98f8fb0e602352564a71efef4f53936dde7a056caed62675a6216624f0db2bc24d8239b8d01f06306bf173dda7a08a1787ba061db01ca0d88359a";
      aarch64-darwin = "72a4499efbbbdf425f92beafc1b1d416e66e6ded60e76d9c9af9c3c13ce11862ba54dffbfbd5cbdef6afaad50f0d57532d3524f83acd88840aecc6891f748732";
    };

in stdenv.mkDerivation rec {
  pname = "kibana";
  version = elk7Version;

  src = fetchurl {
    url = "https://artifacts.elastic.co/downloads/kibana/${pname}-${version}-${plat}-${arch}.tar.gz";
    sha512 = shas.${stdenv.hostPlatform.system} or (throw "Unknown architecture");
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

  meta = with lib; {
    description = "Visualize logs and time-stamped data";
    homepage = "http://www.elasticsearch.org/overview/kibana";
    license = licenses.elastic;
    maintainers = with maintainers; [ offline basvandijk ];
    platforms = with platforms; unix;
  };
}
