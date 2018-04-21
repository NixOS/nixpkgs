{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "vale-${version}";
  version = "0.10.1";
  rev    = "${version}";

  goPackagePath = "github.com/ValeLint/vale";

  src = fetchFromGitHub {
    inherit rev;
    owner  = "ValeLint";
    repo   = "vale";
    sha256 = "1iyc9mny3nb6j3allj3szkiygc2v3gi7l7syq9ifjrm1wknk8wrf";
  };

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "Vale is an open source linter for prose";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
