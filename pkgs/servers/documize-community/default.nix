{ lib, buildGoModule, fetchFromGitHub, go-bindata, go-bindata-assetfs }:

buildGoModule rec {
  pname = "documize-community";
  version = "3.6.0";

  src = fetchFromGitHub {
    owner = "documize";
    repo = "community";
    rev = "v${version}";
    sha256 = "0wic4j7spw9ya1m6yz0mkpqi1px6jd2vk60w8ldx0m0k606wy6ir";
  };

  modSha256 = "1z0v7n8klaxcqv7mvzf3jzgrp78zb4yiibx899ppk6i5qnj4xiv0";

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
