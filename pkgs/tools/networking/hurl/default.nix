{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, installShellFiles
, libxml2
, openssl
, stdenv
, curl
}:

rustPlatform.buildRustPackage rec {
  pname = "hurl";
<<<<<<< HEAD
  version = "4.0.0";
=======
  version = "3.0.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "Orange-OpenSource";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    hash = "sha256-ubzcCY3ccjt2VSZNx9+l3M/z4o7wWcE7USAlA9BnQY0=";
  };

  cargoHash = "sha256-C8WeYFaqF748QZkp/CppqJjF3QW1k7OWXycxSoxKPOI=";
=======
    hash = "sha256-m9hAGm5vmo+J+ntQOK5R4vFEVRhW097D1gvjcE/1CnM=";
  };

  cargoHash = "sha256-KYlax3Q7w27Q6TNwuDmzJhoiFMWnfMhagAuw0+FIW1c=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  buildInputs = [
    libxml2
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    curl
  ];

  # Tests require network access to a test server
  doCheck = false;

  postInstall = ''
    installManPage docs/manual/hurl.1 docs/manual/hurlfmt.1
  '';

  meta = with lib; {
    description = "Command line tool that performs HTTP requests defined in a simple plain text format.";
    homepage = "https://hurl.dev/";
    changelog = "https://github.com/Orange-OpenSource/hurl/blob/${version}/CHANGELOG.md";
    maintainers = with maintainers; [ eonpatapon figsoda ];
    license = licenses.asl20;
  };
}
