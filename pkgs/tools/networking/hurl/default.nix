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
  version = "4.2.0";

  src = fetchFromGitHub {
    owner = "Orange-OpenSource";
    repo = pname;
    rev = version;
    hash = "sha256-77RGS4B5Jwb/J5eOG2A7sdfAU7PnRaxqz5nogpOnj70=";
  };

  cargoHash = "sha256-3D8jyHFrhb3y4yeYtO1GqSyb5wlqUydf/4clsbLjJVE=";

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
    description = "Command line tool that performs HTTP requests defined in a simple plain text format";
    homepage = "https://hurl.dev/";
    changelog = "https://github.com/Orange-OpenSource/hurl/blob/${version}/CHANGELOG.md";
    maintainers = with maintainers; [ eonpatapon figsoda ];
    license = licenses.asl20;
    mainProgram = "hurl";
  };
}
