{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "bore-cli";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "ekzhang";
    repo = "bore";
    rev = "v${version}";
    sha256 = "sha256-KSJ5KYXOwjtK1oE9IpsVKb7H4uuKJroCpM1Dk+2XJlY=";
  };

  cargoSha256 = "sha256-HPMEbHDRmsmcr7Fuhsyr+NkdI9t1sL7q8uzj8sFks0s=";

  # tests do not find grcov path correctly
  meta = with lib; {
    description = "Rust tool to create TCP tunnels";
    homepage = "https://github.com/ekzhang/bore";
    license = licenses.mit;
    maintainers = with maintainers; [ DieracDelta ];
  };
}
