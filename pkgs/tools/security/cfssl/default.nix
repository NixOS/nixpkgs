{ stdenv, buildGoModule, fetchFromGitHub }:

let
  # Embed static files in the built-in webserver
  rice = buildGoModule rec {
    name = "rice";
    src = fetchFromGitHub {
      owner = "GeertJohan";
      repo = "go.rice";
      rev = "v1.0.0";
      sha256 = "0m1pkqnx9glf3mlx5jdaby9yxccbl02jpjgpi4m7x1hb4s2gn6vx";
    };
    vendorSha256 = "0cb5phyl2zm1xnkhvisv0lzgknsi93yzmpayg30w7jc6z4icwnw7";
    subPackages = [ "rice" ];
  };
in
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

  preBuild = ''
    pushd cli/serve
    ${rice}/bin/rice embed-go
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
