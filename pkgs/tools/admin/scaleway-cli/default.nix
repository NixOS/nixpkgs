{ stdenv, fetchFromGitHub, buildGoPackage }:

buildGoPackage rec {
  pname = "scaleway-cli";
  version = "1.20";

  goPackagePath = "github.com/scaleway/scaleway-cli";

  src = fetchFromGitHub {
    owner = "scaleway";
    repo = "scaleway-cli";
    rev = "v${version}";
    sha256 = "14likzp3hl04nq9nmpmh9m5zqjyspy5cyk20dkh03c1nhkd4vcnx";
  };

  meta = with stdenv.lib; {
    description = "Interact with Scaleway API from the command line";
    homepage = "https://github.com/scaleway/scaleway-cli";
    license = licenses.mit;
    maintainers = with maintainers; [ nickhu ];
    platforms = platforms.all;
  };
}
