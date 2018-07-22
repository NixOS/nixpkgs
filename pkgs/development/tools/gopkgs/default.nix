{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "gopkgs-${version}";
  version = "unstable-2017-12-29";
  rev = "b2ea2ecd37740e6ce0e020317d90c729aab4dc6d";

  goPackagePath = "github.com/uudashr/gopkgs";
  goDeps = ./deps.nix;

  src = fetchFromGitHub {
    inherit rev;
    owner = "uudashr";
    repo = "gopkgs";
    sha256 = "1hwzxrf2h8xjbbx6l86mjpjh4csxxsy17zkh8h3qzncyfnsnczzg";
  };

  meta = {
    description = "Tool to get list available Go packages.";
    homepage = https://github.com/uudashr/gopkgs;
    maintainers = with stdenv.lib.maintainers; [ vdemeester ];
    license = stdenv.lib.licenses.mit;
  };
}
