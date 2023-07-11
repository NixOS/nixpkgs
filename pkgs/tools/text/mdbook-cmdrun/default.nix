{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-cmdrun";
  version = "unstable-2023-01-10";

  src = fetchFromGitHub {
    owner = "FauconFan";
    repo = pname;
    rev = "3f6d243cd9de5659f166a5642eb46b2a6d8384e7";
    hash = "sha256-JuKMAb3vwGTju9U1vaS9I39gObTz0JQQV4uol9SmsfM=";
  };

  # Tests are outdated currently, application works fine
  # See for more info: https://github.com/FauconFan/mdbook-cmdrun/issues/2
  doCheck = false;

  cargoHash = "sha256-h3xCnx6byToZx83uWNLz05F3VIDR0D1NVtSOKPuYeG4=";

  meta = with lib; {
    description = "mdbook preprocessor to run arbitrary commands";
    homepage = "https://github.com/FauconFan/mdbook-cmdrun";
    license = licenses.mit;
    maintainers = with maintainers; [ pinpox ];
  };
}
