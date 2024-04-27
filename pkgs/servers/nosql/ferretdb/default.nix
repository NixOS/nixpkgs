{ lib
, buildGoModule
, fetchFromGitHub
, nixosTests
}:

buildGoModule rec {
  pname = "ferretdb";
  version = "1.21.0";

  src = fetchFromGitHub {
    owner = "FerretDB";
    repo = "FerretDB";
    rev = "v${version}";
    hash = "sha256-wTnVZ2C6edXy7+DV5w9Ny1Ry8yKQtahS2AIjFkaJhm8=";
  };

  postPatch = ''
    echo v${version} > build/version/version.txt
    echo nixpkgs     > build/version/package.txt
  '';

  vendorHash = "sha256-1Al7Dxw6EkGZpjmxQWbRU4uV0KT1emNI3YNGbiX87Yc=";

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
    mainProgram = "ferretdb";
    changelog = "https://github.com/FerretDB/FerretDB/releases/tag/v${version}";
    homepage = "https://www.ferretdb.io/";
    license = licenses.asl20;
    maintainers = with maintainers; [ dit7ya noisersup julienmalka ];
  };
}
