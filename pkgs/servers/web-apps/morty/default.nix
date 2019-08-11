{ stdenv, buildGoPackage, fetchgit }:

buildGoPackage rec {
  name = "morty-${version}";
  version = "0.2.0";

  goPackagePath = "github.com/asciimoo/morty";

  src = fetchgit {
    rev = "v${version}";
    url = "https://github.com/asciimoo/morty";
    sha256 = "1wvrdlwbpzizfg7wrcfyf1x6qllp3aw425n88z516wc9jalfqrrm";
  };

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
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
