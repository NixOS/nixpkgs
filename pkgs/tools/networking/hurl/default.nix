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
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "Orange-OpenSource";
    repo = pname;
    rev = version;
    hash = "sha256-ubzcCY3ccjt2VSZNx9+l3M/z4o7wWcE7USAlA9BnQY0=";
  };

  cargoHash = "sha256-C8WeYFaqF748QZkp/CppqJjF3QW1k7OWXycxSoxKPOI=";

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
