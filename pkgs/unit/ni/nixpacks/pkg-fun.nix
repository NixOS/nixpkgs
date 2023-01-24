{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "nixpacks";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "railwayapp";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-SrNYvkJy97GwneA7UClNLaO0fd+ZiMSxCCSgqwESw5Y=";
  };

  cargoHash = "sha256-S/V2PVkL9T/USXAzorDpo0nhRm9DOkNtfw5CADg4oKM=";

  # skip test due FHS dependency
  doCheck = false;

  meta = with lib; {
    description = "App source + Nix packages + Docker = Image Resources";
    homepage = "https://github.com/railwayapp/nixpacks";
    license = licenses.mit;
    maintainers = [ maintainers.zoedsoupe ];
  };
}
