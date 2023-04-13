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
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = pname;
    rev = "refs/tags/${pname}-v${version}";
    hash = "sha256-fT9CJ/WAH5ESU4Ja062U/qNWDmhEfHI1XctnFjgBJ+A=";
  };

  cargoHash = "sha256-rcA94i7JDUBH2JrbWbEQLBMV9R1rBXnS3pNEmbOUr9c=";

  nativeBuildInputs = [
    pkg-config nix
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
