{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "go-bindata";
  version = "3.22.0";

  goPackagePath = "github.com/kevinburke/go-bindata";

  src = fetchFromGitHub {
    owner = "kevinburke";
    repo = pname;
    rev = "v${version}";
    sha256 = "10dq77dml5jvvq2jkdq81a9yjg7rncq8iw8r84cc3dz6l9hxzj0x";
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
