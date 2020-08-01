{ stdenv, buildGoModule, fetchFromGitHub, go-rice }:

buildGoModule rec {
  pname = "cfssl";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "cloudflare";
    repo = "cfssl";
    rev = "v${version}";
    sha256 = "07qacg95mbh94fv64y577zyr4vk986syf8h5l8lbcmpr0zcfk0pd";
  };

  subPackages = [
    "cmd/cfssl"
    "cmd/cfssljson"
    "cmd/cfssl-bundle"
    "cmd/cfssl-certinfo"
    "cmd/cfssl-newkey"
    "cmd/cfssl-scan"
    "cmd/multirootca"
    "cmd/mkbundle"
  ];

  vendorSha256 = null;

  nativeBuildInputs = [ go-rice ];

  preBuild = ''
    pushd cli/serve
    rice embed-go
    popd
  '';

  buildFlagsArray = ''
    -ldflags=
      -s -w
      -X github.com/cloudflare/cfssl/cli/version.version=v${version}
  '';

  meta = with stdenv.lib; {
    homepage = "https://cfssl.org/";
    description = "Cloudflare's PKI and TLS toolkit";
    license = licenses.bsd2;
    maintainers = with maintainers; [ mbrgm ];
  };
}
