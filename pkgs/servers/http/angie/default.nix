{
  callPackage,
  lib,
  fetchurl,
  nixosTests,
  withAcme ? false,
  ...
}@args:

callPackage ../nginx/generic.nix args rec {
  pname = "angie";
  version = "1.11.2";

  src = fetchurl {
    url = "https://download.angie.software/files/angie-${version}.tar.gz";
    hash = "sha256-Or6pG7lMlzs5SiQl5KYXyNViO6f82PtWLjIYRXDsvEc=";
  };

  configureFlags = lib.optionals withAcme [
    "--with-http_acme_module"
    "--http-acme-client-path=/var/lib/nginx/acme"
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
    angie-http3 = nixosTests.nginx-http3.angie;
  };

  meta = {
    description = "Angie is an efficient, powerful, and scalable web server that was forked from nginx";
    homepage = "https://angie.software/en/";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ izorkin ];
  };
}
