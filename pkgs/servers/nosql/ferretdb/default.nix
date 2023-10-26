{ lib
, buildGo121Module
, fetchFromGitHub
, nixosTests
}:

buildGo121Module rec {
  pname = "ferretdb";
  version = "1.12.1";

  src = fetchFromGitHub {
    owner = "FerretDB";
    repo = "FerretDB";
    rev = "v${version}";
    hash = "sha256-3fLTiI13Mm+G6EEEOzCuJ9KVebCq5O54hyH6JiCRRL8=";
  };

  postPatch = ''
    echo v${version} > build/version/version.txt
    echo nixpkgs     > build/version/package.txt
  '';

  vendorHash = "sha256-l45KFDpqprBWnsVRhOJkCWolZapArRvjUb52R5hc5zs=";

  CGO_ENABLED = 0;

  subPackages = [ "cmd/ferretdb" ];

  # tests in cmd/ferretdb are not production relevant
  doCheck = false;

  # the binary panics if something required wasn't set during compilation
  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/ferretdb --version | grep ${version}
  '';

  passthru.tests = nixosTests.ferretdb;

  meta = with lib; {
    description = "A truly Open Source MongoDB alternative";
    homepage = "https://www.ferretdb.io/";
    license = licenses.asl20;
    maintainers = with maintainers; [ dit7ya noisersup julienmalka ];
  };
}
