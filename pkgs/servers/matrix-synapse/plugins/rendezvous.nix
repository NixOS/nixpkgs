{ lib, buildPythonPackage, fetchFromGitHub, rustPlatform, setuptools-rust }:

buildPythonPackage rec {
  pname = "matrix-http-rendezvous-synapse";
  version = "0.1.12";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "matrix-org";
    repo = "rust-http-rendezvous-server";
    rev = "v${version}";
    sha256 = "sha256-minwa+7HLTNSBtBtt5pnoHsFnNEh834nsVw80+FIQi8=";
  };

  postPatch = ''
    cp ${./rendezvous-Cargo.lock} Cargo.lock
  '';

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src postPatch;
    name = "${pname}-${version}";
    hash = "sha256-TyxDq6YxZUArRj5gpjB1afDQgtUlCVer3Uhq6YKvVYM=";
  };

  nativeBuildInputs = [
    setuptools-rust
  ] ++ (with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ]);

  buildAndTestSubdir = "synapse";


  pythonImportsCheck = [ "matrix_http_rendezvous_synapse" ];

  meta = with lib; {
    description = "Implementation of MSC3886: Simple rendezvous capability";
    homepage = "https://github.com/matrix-org/rust-http-rendezvous-server";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
