{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, libxml2
, openssl
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
  ];

  buildInputs = [
    libxml2
    openssl
  ];

  # Tests require network access to a test server
  doCheck = false;

  cargoSha256 = "sha256-tAg3xwmh7SjJsm9r5TnhXHIDLpUQpz3YDS6gWxFgps4=";

  meta = with lib; {
    description = "Command line tool that performs HTTP requests defined in a simple plain text format.";
    homepage = "https://hurl.dev/";
    maintainers = with maintainers; [ eonpatapon ];
    license = licenses.asl20;
  };
}
