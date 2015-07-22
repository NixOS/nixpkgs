{ callPackage, fetchgit, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "1.1.4";

  src = fetchgit {
    url = "git://git.gniibe.org/gnuk/gnuk.git";
    rev = "e7e8b9f5ca414a5c901f61b0f043c8da42414103";
    sha256 = "0zjpgvmnvgvfqp9cd9g8ns9z05alimwcdqx16l22604ywnhdy99l";
  };
})
