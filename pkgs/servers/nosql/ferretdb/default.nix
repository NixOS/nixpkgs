{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "ferretdb";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "FerretDB";
    repo = "FerretDB";
    rev = "v${version}";
    sha256 = "sha256-lJlj5GNgrllcaEednxVCmMPHG2aU4z3mKkm9t0cO5Tk=";
  };

  postPatch = ''
    echo v${version} > build/version/version.txt
    echo nixpkgs     > build/version/package.txt
  '';

  vendorSha256 = "sha256-I5ucq3K0lRsokG9lahmBUH9mIYa5tgHnL+vxKSzW1hw=";

  CGO_ENABLED = 0;

  subPackages = [ "cmd/ferretdb" ];

  tags = [ "ferretdb_tigris" ];

  meta = with lib; {
    description = "A truly Open Source MongoDB alternative";
    homepage = "https://www.ferretdb.io/";
    license = licenses.asl20;
    maintainers = with maintainers; [ dit7ya noisersup julienmalka ];
  };
}
