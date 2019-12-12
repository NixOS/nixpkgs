{ lib, buildGoModule, fetchFromGitHub, go-bindata, go-bindata-assetfs }:

buildGoModule rec {
  pname = "documize-community";
  version = "3.5.2";

  src = fetchFromGitHub {
    owner = "documize";
    repo = "community";
    rev = "v${version}";
    sha256 = "0wi85ag5n49zqs68gznifza8qv8zkg9l8z1q6ckkvbkl2f3zpdl5";
  };

  modSha256 = "08f1116a3w3j53z34l5xdg4hrfhqf6glz4mh0zgk70w5vdqzjr7r";

  buildInputs = [ go-bindata-assetfs go-bindata ];

  subPackages = [ "edition/community.go" ];

  postInstall = ''
    # `buildGoModule` calls `go install` (without `go build` first), so
    # `-o bin/documize` doesn't work.
    mv $out/bin/community $out/bin/documize
  '';

  meta = with lib; {
    description = "Open source Confluence alternative for internal & external docs built with Golang + EmberJS";
    license = licenses.agpl3;
    maintainers = with maintainers; [ ma27 elseym ];
    homepage = https://www.documize.com/;
  };
}
