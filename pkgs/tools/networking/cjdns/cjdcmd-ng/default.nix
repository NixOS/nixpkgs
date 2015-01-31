{ stdenv, buildGoPackage, goPackages, fetchurl, cjdns }:

with goPackages;

let
  go-cjdns = buildGoPackage rec {
    version = "2.1.0";
    name = "go-cjdns-${version}";

    goPackagePath = "github.com/ehmry/go-cjdns";
    subPackages = [ "admin" "config" "key" ];

    src = fetchurl {
      url = "https://${goPackagePath}/archive/v${version}.tar.gz";
      name = "${name}.tar.gz";
      sha256 = "1ys47zdz9dv45w5j31z020z72yy6yrfas9c5777mwl42925s9bnf";
    };
    buildInputs = [ goconvey ];
    propagatedBuildInputs = [ crypto go-bencode ];
  };
in
let version = "0.8.3"; in
buildGoPackage rec {
  name = "cjdcmd-ng-${version}";
  goPackagePath = "github.com/ehmry/cjdcmd-ng";

  src = fetchurl {
    url = "https://${goPackagePath}/archive/v${version}.tar.gz";
    name = "${name}.tar.gz";
    sha256 = "10j2f00byz4vrcyk8mxw5f9l8ikkdmi8044mnnwndkjky3m9xj43";
  };

  buildInputs = [ go-cjdns cobra ];

  meta = with stdenv.lib; {
    description = "Utility for interacting with CJDNS";
    homepage = https://github.com/ehmry/cjdcmd-ng;
    mantainers = with maintainers; [ emery ];
    license = licenses.gpl3Plus;
    platforms = cjdns.meta.platforms;
  };
}