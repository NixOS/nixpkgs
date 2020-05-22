{ lib, buildGoModule, fetchFromGitHub, go-bindata, go-bindata-assetfs }:

buildGoModule rec {
  pname = "documize-community";
  version = "3.8.0";

  src = fetchFromGitHub {
    owner = "documize";
    repo = "community";
    rev = "v${version}";
    sha256 = "0jrqab0c2nnw8632g1f6zll3dycn7xyk01ycmn969i5qxx70am50";
  };

  modSha256 = "0f66z6cr0d8f6cxbkjsnsn6cwwx8qjn2w0i6ag8j874gbxjgycr8";

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
