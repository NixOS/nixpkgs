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
  version = "3.0.1";

  src = fetchFromGitHub {
    owner = "Orange-OpenSource";
    repo = pname;
    rev = version;
    hash = "sha256-Rh8HBUR3IXYs/0NZJAKk4mHOjliRIAgEsgR402i7FX4=";
  };

  cargoHash = "sha256-9AXusLvkZQ3g4u7z03dy8eXzQ59aRSHFR+uyt3MwKhg=";

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
