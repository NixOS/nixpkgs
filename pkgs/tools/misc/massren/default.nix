{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "massren";
  version = "1.5.6";

  src = fetchFromGitHub {
    owner = "laurent22";
    repo = "massren";
    rev = "v${version}";
    sha256 = "sha256-17y+vmspvZKKRRaEwzP3Zya4r/z+2aSGG6oNZiA8D64=";
  };

  goPackagePath = "github.com/laurent22/massren";

  meta = with lib; {
    description = "Easily rename multiple files using your text editor";
    license = licenses.mit;
    homepage = "https://github.com/laurent22/massren";
    maintainers = with maintainers; [ andrew-d ];
  };
}
