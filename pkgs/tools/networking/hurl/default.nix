{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, pkg-config
, python3
, installShellFiles
, libxml2
, openssl
, curl
}:

rustPlatform.buildRustPackage rec {
  pname = "hurl";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "Orange-OpenSource";
    repo = pname;
    rev = version;
    sha256 = "sha256-ud4ARpiyMcYwPKsLbeK4MMBLzkD/tecF1L1vWyYpKmY=";
  };

  nativeBuildInputs = [
    pkg-config
    python3
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

  cargoSha256 = "sha256-tmHP7xwVce/hh8nX1LO/zwPIlDZkICPMlBjZjuv37xU=";

  postInstall = ''
    python ci/gen_manpage.py docs/hurl.md > hurl.1
    python ci/gen_manpage.py docs/hurlfmt.md > hurlfmt.1
    installManPage hurl.1 hurlfmt.1
  '';

  meta = with lib; {
    description = "Command line tool that performs HTTP requests defined in a simple plain text format.";
    homepage = "https://hurl.dev/";
    changelog = "https://github.com/Orange-OpenSource/hurl/raw/${version}/CHANGELOG.md";
    maintainers = with maintainers; [ eonpatapon ];
    license = licenses.asl20;
  };
}
