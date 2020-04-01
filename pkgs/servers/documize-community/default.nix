{ lib, buildGoModule, fetchFromGitHub, go-bindata, go-bindata-assetfs }:

buildGoModule rec {
  pname = "documize-community";
  version = "3.7.0";

  src = fetchFromGitHub {
    owner = "documize";
    repo = "community";
    rev = "v${version}";
    sha256 = "1pcldf9lqvpb2h2a3kr3mahj2v1jasjwrszj6czjmkyml7x2sz7c";
  };

  modSha256 = "1z0v7n8klaxcqv7mvzf3jzgrp78zb4yiibx899ppk6i5qnj4xiv0";

  nativeBuildInputs = [ go-bindata go-bindata-assetfs ];

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
