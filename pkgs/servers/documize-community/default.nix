{ lib, buildGoPackage, fetchFromGitHub, go-bindata, go-bindata-assetfs }:

buildGoPackage rec {
  pname = "documize-community";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "documize";
    repo = "community";
    rev = "v${version}";
    sha256 = "01q7yx35gp41lnm9zbwq0maf7wiv86mi6fww3hl1cddmgdlksss9";
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
