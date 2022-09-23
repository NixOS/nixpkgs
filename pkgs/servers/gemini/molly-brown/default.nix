{ lib, buildGoPackage, fetchgit, nixosTests }:

buildGoPackage rec {
  pname = "molly-brown";
  version = "unstable-2020-08-19";
  rev = "48f9a206c03c0470e1c132b9667c6daa3583dada";

  goPackagePath = "tildegit.org/solderpunk/molly-brown";

  src = fetchgit {
    inherit rev;
    url = "https://tildegit.org/solderpunk/molly-brown.git";
    sha256 = "1w79a25mbgav95p78fkdm9j62chwwpkqv0m2wmh5my03yq398gya";
  };

  goDeps = ./deps.nix;

  passthru.tests.basic = nixosTests.molly-brown;

  meta = with lib; {
    description = "Full-featured Gemini server";
    homepage = "https://tildegit.org/solderpunk/molly-brown";
    maintainers = with maintainers; [ ehmry ];
    license = licenses.bsd2;
  };
}
