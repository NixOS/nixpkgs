{ lib
, buildGoModule
, fetchFromGitHub
, nixosTests
}:

buildGoModule rec {
  pname = "ferretdb";
  version = "1.23.1";

  src = fetchFromGitHub {
    owner = "FerretDB";
    repo = "FerretDB";
    rev = "v${version}";
    hash = "sha256-Y4mMh/3I2ajXnHCR9PQXvuUA/BVIfgNrnAIU0/o7QFw=";
  };

  postPatch = ''
    echo v${version} > build/version/version.txt
    echo nixpkgs     > build/version/package.txt
  '';

  vendorHash = "sha256-qBEaL0+sBcT8PTet4Znm4OPHFy+UcIuvwI2ywyv4nDc=";

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
    description = "Truly Open Source MongoDB alternative";
    mainProgram = "ferretdb";
    changelog = "https://github.com/FerretDB/FerretDB/releases/tag/v${version}";
    homepage = "https://www.ferretdb.com/";
    license = licenses.asl20;
    maintainers = with maintainers; [ dit7ya noisersup julienmalka ];
  };
}
