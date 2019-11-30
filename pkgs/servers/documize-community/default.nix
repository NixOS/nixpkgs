{ lib, buildGoModule, fetchFromGitHub, go-bindata, go-bindata-assetfs }:

buildGoModule rec {
  pname = "documize-community";
  version = "3.5.1";

  src = fetchFromGitHub {
    owner = "documize";
    repo = "community";
    rev = "v${version}";
    sha256 = "1dnb5b24x50c258fk47i7vngv28gai0mywns6nvgm3q59zyzphbj";
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
