{ lib, buildGoPackage, fetchgit, nixosTests }:

buildGoPackage rec {
  pname = "molly-brown";
  version = "unstable-2020-07-06";
  rev = "2e510328ef1737c67641c588095e4628e3dfa8d3";

  goPackagePath = "tildegit.org/solderpunk/molly-brown";

  src = fetchgit {
    inherit rev;
    url = "https://tildegit.org/solderpunk/molly-brown.git";
    sha256 = "0c2pmkcs5a04h2vwzbhj6rg47mb9wcmkh22i56kx7clh51wbbvc4";
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
