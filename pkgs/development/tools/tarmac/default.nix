{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, pkg-config
, openssl_1_1
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "tarmac";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "Roblox";
    repo = "tarmac";
    rev = "v${version}";
    sha256 = "sha256-O6qrAzGiAxiE56kpuvH/jDKHRXxHZ2SlDL5nwOOd4EU=";
  };

  cargoSha256 = "sha256-QnpowYv/TBXjPHK8z6KAzN3gSsfNOf9POybqsyugeWc=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl_1_1
  ] ++ lib.optionals stdenv.isDarwin [
    Security
  ];

  meta = with lib; {
    description = "Resource compiler and asset manager for Roblox";
    longDescription = ''
      Tarmac is a resource compiler and asset manager for Roblox projects.
      It helps enable hermetic place builds when used with tools like Rojo.
    '';
    homepage = "https://github.com/Roblox/tarmac";
    downloadPage = "https://github.com/Roblox/tarmac/releases/tag/v${version}";
    changelog = "https://github.com/Roblox/tarmac/raw/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ wackbyte ];
  };
}
