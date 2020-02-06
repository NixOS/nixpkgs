{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "massren";
  version = "1.5.4";

  src = fetchFromGitHub {
    owner = "laurent22";
    repo = "massren";
    rev = "v${version}";
    sha256 = "1bn6qy30kpxi3rkr3bplsc80xnhj0hgfl0qaczbg3zmykfmsl3bl";
  };

  goPackagePath = "github.com/laurent22/massren";

  meta = with lib; {
    description = "Easily rename multiple files using your text editor";
    license = licenses.mit;
    homepage = https://github.com/laurent22/massren;
    maintainers = with maintainers; [ andrew-d ];
  };
}
