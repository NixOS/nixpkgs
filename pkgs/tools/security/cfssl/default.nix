{ stdenv, buildGoModule, fetchFromGitHub, go-rice }:

buildGoModule rec {
  pname = "cfssl";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "cloudflare";
    repo = "cfssl";
    rev = "v${version}";
    sha256 = "1yzxz2l7h2d3f8j6l9xlm7g9659gsa17zf4q0883s0jh3l3xgs5n";
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

  doCheck = false;

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
