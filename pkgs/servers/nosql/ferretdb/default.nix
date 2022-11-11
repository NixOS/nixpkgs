{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "ferretdb";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "FerretDB";
    repo = "FerretDB";
    rev = "v${version}";
    sha256 = "sha256-oSNE7JJwni+X5AiAmHLuxVI9gMh3AT84xejWgmJSlzk=";
  };

  postPatch = ''
    echo ${version} > internal/util/version/gen/version.txt
  '';

  vendorSha256 = "sha256-H/EXUPNMTD6mgcUFupxL5wTLHvAlH5L6bv2GmvsbKms=";

  CGO_ENABLED = 0;

  subPackages = [ "cmd/ferretdb" ];

  meta = with lib; {
    description = "A truly Open Source MongoDB alternative";
    homepage = "https://github.com/FerretDB/FerretDB";
    license = licenses.asl20;
    maintainers = with maintainers; [ dit7ya ];
  };
}
