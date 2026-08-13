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
  version = "1.12.1";

  src = fetchurl {
    url = "https://download.angie.software/files/angie-${version}.tar.gz";
    hash = "sha256-X08gO+Kspv4gdwtInHIORuUdM35SEGXn5HK2HiTj0vU=";
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
    knownVulnerabilities = [
      "angie is insufficiently maintained in nixpkgs. Security updates are frequently delayed. Please consider stepping up as maintainer or switching to an alternative."
    ];
  };
}
