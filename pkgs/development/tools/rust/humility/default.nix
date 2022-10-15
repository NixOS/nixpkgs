{ lib
, rustPlatform
, fetchFromGitHub
, libusb
, libftdi
, cargo-readme
, pkg-config
}:

rustPlatform.buildRustPackage rec {
  pname = "humility";
  version = "unstable-2022-09-15";

  nativeBuildInputs = [ pkg-config cargo-readme ];
  buildInputs = [ libusb libftdi ];

  src = fetchFromGitHub {
    owner = "oxidecomputer";
    repo = pname;
    rev = "d336c21c7b6da7f8203a9331c7657581de2bc6ad";
    sha256 = "sha256-yW7QcxTWbL2YsV2bvfhbqQ2nawlPQbYxBfIGCWo28GY=";
  };

  cargoSha256 = "sha256-UhO8VO3OCfYc8Xq/P+l9f5ZrhOD/TBzSClAeAXLJLlc=";

  meta = with lib; {
    description = "Debugger for Hubris";
    homepage = "https://github.com/oxidecomputer/humility";
    license = with licenses; [ mpl20 ];
    maintainers = with maintainers; [ therishidesai ];
  };
}
