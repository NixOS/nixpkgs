{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "ferretdb";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "FerretDB";
    repo = "FerretDB";
    rev = "v${version}";
    sha256 = "sha256-WSdscZ1/Dix83RE95Iv61rdaSBWx1GMi6qOIPNus+ZI=";
  };

  postPatch = ''
    echo ${version} > internal/util/version/gen/version.txt
  '';

  vendorSha256 = "sha256-fGmGE08w9w2QnBVdMZ2IKo8Zq3euJGCBVTTHNKYFY3U=";

  CGO_ENABLED = 0;

  subPackages = [ "cmd/ferretdb" ];

  meta = with lib; {
    description = "A truly Open Source MongoDB alternative";
    homepage = "https://github.com/FerretDB/FerretDB";
    license = licenses.asl20;
    maintainers = with maintainers; [ dit7ya ];
  };
}
