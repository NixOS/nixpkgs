{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "ferretdb";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "FerretDB";
    repo = "FerretDB";
    rev = "v${version}";
    sha256 = "sha256-wjqTYrAVrUl+i+2glSUW1xS/qjvTqRXYu4s3F5Wi0Sc=";
  };

  postPatch = ''
    echo ${version} > internal/util/version/gen/version.txt
  '';

  vendorSha256 = "sha256-wjlGAhut9/jZ2GmKg7XmenphkgxWn0VbuvYEtORpbtw=";

  CGO_ENABLED = 0;

  subPackages = [ "cmd/ferretdb" ];

  meta = with lib; {
    description = "A truly Open Source MongoDB alternative";
    homepage = "https://github.com/FerretDB/FerretDB";
    license = licenses.asl20;
    maintainers = with maintainers; [ dit7ya ];
  };
}
