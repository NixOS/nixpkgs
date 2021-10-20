{ lib, stdenv, fetchFromGitHub, ... }:

stdenv.mkDerivation rec {
  pname = "tt-rss-plugin-feediron";
  version = "v1.32";

  src = fetchFromGitHub {
    owner = "feediron";
    repo = "ttrss_plugin-feediron";
    rev = version;
    sha256 = "0a4nq0k0zmgmx7dzz70smhp0yxp7jynk9djz0nnbaa138h8888pr";
  };

  installPhase = ''
    mkdir -p $out/feediron

    cp -R bin $out/feediron/bin
    cp -R filters $out/feediron/filters
    cp -R preftab $out/feediron/preftab
    cp -R recipes $out/feediron/recipes
    cp init.php $out/feediron/init.php
  '';

  meta = with lib; {
    description = "Evolution of ttrss_plugin-af_feedmod";
    longDescription = ''
      This is a plugin for Tiny Tiny RSS (tt-rss).
      It allows you to replace an article's contents by the contents of an element on the linked URL's page

      i.e. create a "full feed".
    '';
    license = licenses.mit;
    homepage = "https://github.com/feediron/ttrss_plugin-feediron";
    maintainers = with maintainers; [ milogert ];
    platforms = platforms.all;
  };
}
