{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "autoadb";
  version = "unstable-2020-06-01";

  src = fetchFromGitHub {
    owner = "rom1v";
    repo = pname;
    rev = "7f8402983603a9854bf618a384f679a17cd85e2d";
    sha256 = "sha256-9Sv38dCtvbqvxSnRpq+HsIwF/rfLUVZbi0J+mltLres=";
  };

  cargoSha256 = "1gzg1lhq8gp790mrc8fw8dg146k8lg20pnk45m2ssnmdka0826f7";

  meta = with lib; {
    description = "Execute a command whenever a device is adb-connected";
    homepage = "https://github.com/rom1v/autoadb";
    license = licenses.asl20;
    maintainers = with maintainers; [ shawn8901 ];
    mainProgram = "autoadb";
  };
}
