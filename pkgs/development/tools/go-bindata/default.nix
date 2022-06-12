{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "go-bindata";
  version = "3.23.0";

  goPackagePath = "github.com/kevinburke/go-bindata";

  src = fetchFromGitHub {
    owner = "kevinburke";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-pIEkD0HD/6JFOzkvEG9j9yQP7hLWvmXU3MiyvVFH2rY=";
  };

  subPackages = [ "go-bindata" ];

  meta = with lib; {
    homepage = "https://github.com/kevinburke/go-bindata";
    changelog = "https://github.com/kevinburke/go-bindata/blob/v${version}/CHANGELOG.md";
    description = "A small utility which generates Go code from any file, useful for embedding binary data in a Go program";
    maintainers = with maintainers; [ cstrahan ];
    license = licenses.cc0;
  };
}
