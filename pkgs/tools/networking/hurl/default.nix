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
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "Orange-OpenSource";
    repo = pname;
    rev = version;
    sha256 = "sha256-BmBqFJ64Nolq+eGZ5D3LQU3Ek2Gs+HpH/bptCQScbIg=";
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

  cargoSha256 = "sha256-tAg3xwmh7SjJsm9r5TnhXHIDLpUQpz3YDS6gWxFgps4=";

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
