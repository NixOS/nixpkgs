{ callPackage
, runCommand
, lib
, fetchurl
, nixosTests
, withQuic ? false
, fetchpatch
, ...
}@args:

callPackage ../nginx/generic.nix args rec {
  version = "1.4.0";
  pname = if withQuic then "angieQuic" else "angie";

  src = fetchurl {
    url = "https://download.angie.software/files/angie-${version}.tar.gz";
    hash = "sha256-gaQsPwoxtt6oVSDX1JCWvyUwDQaNprya79CCwu4z8b4=";
  };

  configureFlags = lib.optional withQuic [
    "--with-http_v3_module"
  ];

  preInstall = ''
    if [[ -e man/angie.8 ]]; then
      installManPage man/angie.8
    fi
  '';

  postInstall = ''
    ln -s $out/bin/nginx $out/bin/angie
  '';

  passthru.tests = {
    angie = nixosTests.nginx-variants.angie;
    angie-api = nixosTests.angie-api;
    angie-http3 = nixosTests.nginx-http3.angieQuic;
  };

  meta = {
    description = "Angie is an efficient, powerful, and scalable web server that was forked from nginx";
    homepage    = "https://angie.software/en/";
    license     = lib.licenses.bsd2;
    platforms   = lib.platforms.all;
    maintainers = with lib.maintainers; [ izorkin ];
  };
}
