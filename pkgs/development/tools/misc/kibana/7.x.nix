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
      x86_64-linux  = "f0f9f65b6ba3cc401a519f764314854f6f1f22a9c3b55dfc5a4921455d64fc0d5b8352d267217076da82157553f235ab3d2506497132f23789b126205177e86b";
      x86_64-darwin = "2ba707a0e7a5c34be98ee5e299b8f1d9ace99a626112efd48ca08bfc9640374ec37fc1761c9ef91599e7a5bf5055d2731759b0337952d7767b02d9c46640be71";
      aarch64-linux = "6899c46a06cceb3bfa5db22cdad90db3063b3859c6059a379ac29ce5755073e45b6914491c7c0ec92c48344c1658ea68f7453992d1a39b70782f699315d175de";
      aarch64-darwin = "194b7288f394ff39af3e114099a8f0f847091fd50231ee50c12105189e2b1dfdff8971795c2c22275ff113734e543cfaf51940682d77576c89d2d5bce9b26b92";
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
