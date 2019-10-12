{ lib, buildGoPackage, fetchFromGitHub, go-bindata, go-bindata-assetfs }:

buildGoPackage rec {
  pname = "documize-community";
  version = "3.3.1";

  src = fetchFromGitHub {
    owner = "documize";
    repo = "community";
    rev = "v${version}";
    sha256 = "1n7cdi76yfdk79ky7six72jg2px0b4hb9s16nshz3qvss469dn2j";
  };

  goPackagePath = "github.com/documize/community";

  buildInputs = [ go-bindata-assetfs go-bindata ];

  buildPhase = ''
    runHook preBuild

    pushd go/src/github.com/documize/community
    go build -gcflags="all=-trimpath=$GOPATH" -o bin/documize ./edition/community.go
    popd

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $bin/bin
    cp go/src/github.com/documize/community/bin/documize $bin/bin

    runHook postInstall
  '';

  meta = with lib; {
    description = "Open source Confluence alternative for internal & external docs built with Golang + EmberJS";
    license = licenses.agpl3;
    maintainers = with maintainers; [ ma27 elseym ];
    homepage = https://www.documize.com/;
  };
}
