{ lib
, boost
, fetchFromGitHub
, libsodium
, nix
, pkg-config
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "harmonia";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = pname;
    rev = "refs/tags/${pname}-v${version}";
    hash = "sha256-BD61xBNlHvw3gsgfU2FgNsGpqkHbGZ+qvVfBYgQ1TJY=";
  };

  cargoHash = "sha256-xok7LutDrrN+lg+Nj8bG/XjMytybo+DOrd7o64PXBIE=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    boost
    libsodium
    nix
  ];

  meta = with lib; {
    description = "Nix binary cache";
    homepage = "https://github.com/helsinki-systems/harmonia";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
