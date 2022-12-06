{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "ferretdb";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "FerretDB";
    repo = "FerretDB";
    rev = "v${version}";
    sha256 = "sha256-BjGK1HvAFBs82bDyI6A7QsJcIaEjEKCw3dyiSqaS2tA=";
  };

  postPatch = ''
    echo ${version} > internal/util/version/gen/version.txt
  '';

  vendorSha256 = "sha256-xmUSjkl41jwC/vaUcqZBvLo2wWp8XlXjzzemN5Ja2gg=";

  CGO_ENABLED = 0;

  subPackages = [ "cmd/ferretdb" ];

  meta = with lib; {
    description = "A truly Open Source MongoDB alternative";
    homepage = "https://github.com/FerretDB/FerretDB";
    license = licenses.asl20;
    maintainers = with maintainers; [ dit7ya ];
  };
}
