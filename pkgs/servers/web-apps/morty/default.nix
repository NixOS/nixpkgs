{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "morty";
  version = "0.2.0";

  goPackagePath = "github.com/asciimoo/morty";

  src = fetchFromGitHub {
    owner = "asciimoo";
    repo = "morty";
    rev = "v${version}";
    sha256 = "sha256-NWfsqJKJcRPKR8gWQbgal1JsenDesczPcz/+uzhtefM=";
  };

  goDeps = ./deps.nix;

  meta = with lib; {
    homepage = "https://github.com/asciimoo/morty";
    maintainers = with maintainers; [ leenaars ];
    license = licenses.agpl3;
    description = "Privacy aware web content sanitizer proxy as a service";
    longDescription = ''
      Morty is a web content sanitizer proxy as a service. It rewrites web
      pages to exclude malicious HTML tags and attributes. It also replaces
      external resource references to prevent third party information leaks.

      The main goal of morty is to provide a result proxy for searx, but it
      can be used as a standalone sanitizer service too.

      Features:

      * HTML sanitization
      * Rewrites HTML/CSS external references to locals
      * JavaScript blocking
      * No Cookies forwarded
      * No Referrers
      * No Caching/Etag
      * Supports GET/POST forms and IFrames
      * Optional HMAC URL verifier key to prevent service abuse
    '';
  };
}
