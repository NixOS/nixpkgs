{ stdenv, fetchFromGitHub, callPackage, makeWrapper, openssl }:

let
  nodePackages = callPackage (import ../../top-level/node-packages.nix) {
    self = nodePackages;
    generated = ./package.nix;
  };

in nodePackages.buildNodePackage rec {
  name    = "dnschain-${version}";
  version = "0.5.3";

  src = fetchFromGitHub {
    owner  = "okTurtles";
    repo   = "dnschain";
    rev    = "a8d477f9ad33d7790f94ffc563e2205823e62515";
    sha256 = "0j5glbxf0fxnxl4l1lysb3a619b18rk0l1ks57wd255llc2mw7zy";
  };

  deps = with nodePackages; [
    by-spec."bluebird"."2.9.9"
    by-spec."bottleneck"."1.5.x"
    by-spec."event-stream"."3.2.2"
    by-spec."express"."4.11.2"
    by-spec."hiredis"."0.4.1"
    by-spec."json-rpc2"."0.8.1"
    by-spec."lodash"."3.1.0"
    by-spec."native-dns"."git+https://github.com/okTurtles/node-dns.git#08433ec98f517eed3c6d5e47bdf62603539cd402"
    by-spec."native-dns-packet"."0.1.1"
    by-spec."nconf"."0.7.1"
    by-spec."properties"."1.2.1"
    by-spec."redis"."0.12.x"
    by-spec."string"."2.0.1"
    by-spec."winston"."0.8.0"
    by-spec."superagent"."0.21.0"
  ];

  buildInputs = [ makeWrapper nodePackages.coffee-script ];
  postInstall = ''
      wrapProgram $out/bin/dnschain --suffix PATH : ${openssl.bin}/bin
  '';

  meta = with stdenv.lib; {
    description = "A blockchain-based DNS + HTTP server";
    homepage    = https://okturtles.com/;
    license     = licenses.mpl20;
    maintainers = with maintainers; [ rnhmjoj ];
    platforms   = platforms.unix;
  };

}
