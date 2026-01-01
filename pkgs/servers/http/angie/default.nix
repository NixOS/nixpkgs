{
  callPackage,
  lib,
  fetchurl,
  nixosTests,
  withAcme ? false,
  ...
}@args:

callPackage ../nginx/generic.nix args rec {
<<<<<<< HEAD
  pname = "angie";
  version = "1.11.0";

  src = fetchurl {
    url = "https://download.angie.software/files/angie-${version}.tar.gz";
    hash = "sha256-6ZR8gJZVufdGpyuQxbrcW3Us70rMiHztwGQImVlEVrM=";
=======
  version = "1.10.2";
  pname = "angie";

  src = fetchurl {
    url = "https://download.angie.software/files/angie-${version}.tar.gz";
    hash = "sha256-pcKrk33ySoDnhq9WOJIvRuqKc9FhQYPIyQKYrocwlLg=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
