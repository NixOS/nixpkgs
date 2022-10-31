{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "ferretdb";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "FerretDB";
    repo = "FerretDB";
    rev = "v${version}";
    sha256 = "sha256-b12188yIEv2Ne0jhrPh6scvJyu+SipYvySe81Z+gYrc=";
  };

  postPatch = ''
    echo ${version} > internal/util/version/gen/version.txt
  '';

  vendorSha256 = "sha256-Tm7uuvs/OyhO1cjtwtiaokjyXF1h01Ev88ofT9gpWXs=";

  CGO_ENABLED = 0;

  subPackages = [ "cmd/ferretdb" ];

  meta = with lib; {
    description = "A truly Open Source MongoDB alternative";
    homepage = "https://github.com/FerretDB/FerretDB";
    license = licenses.asl20;
    maintainers = with maintainers; [ dit7ya ];
  };
}
