{ fetchCrate, lib, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "runiq";
  version = "2.0.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-qcgPuJOpK2fCsHAgzoIKF7upb9B3ySIZkpu9xf4JnCc=";
  };

  cargoHash = "sha256-WSMV0GNKNckN9uSPN647iDloGkNtaKcrZbeyglUappc=";

  meta = with lib; {
    description = "An efficient way to filter duplicate lines from input, à la uniq";
    homepage = "https://github.com/whitfin/runiq";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
