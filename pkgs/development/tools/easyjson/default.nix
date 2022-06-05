{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "easyjson";
  version = "0.7.7";
  goPackagePath = "github.com/mailru/easyjson";
  goDeps = ./deps.nix;

  src = fetchFromGitHub {
    owner = "mailru";
    repo = "easyjson";
    rev = "v${version}";
    sha256 = "0clifkvvy8f45rv3cdyv58dglzagyvfcqb63wl6rij30c5j2pzc1";
  };

  meta = with lib; {
    homepage = "https://github.com/mailru/easyjson";
    description = "Fast JSON serializer for golang";
    license = licenses.mit;
    maintainers = with maintainers; [ Madouura ];
  };
}
