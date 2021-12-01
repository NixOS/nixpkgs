{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "mubeng";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "kitabisa";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-jwBDa/TfXrD+f0q4nyQkpi52Jwl1XWZrMd3fPowNzgA=";
  };

  vendorSha256 = "sha256-/K1kBuxGEDUCBC7PiSpQRv1NEvTKwN+vNg2rz7pg838=";

  meta = with lib; {
    description = "Proxy checker and IP rotator";
    homepage = "https://github.com/kitabisa/mubeng";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
