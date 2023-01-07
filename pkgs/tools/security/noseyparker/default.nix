{ lib
, rustPlatform
, fetchFromGitHub
, cmake
, openssl
, pkg-config
, hyperscan
}:

rustPlatform.buildRustPackage rec {
  pname = "noseyparker";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "praetorian-inc";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-7hDrHYxVKduQl3kpLUHEXDPKTz1B74GjxKC5XEPYEmc=";
  };

  cargoSha256 = "sha256-JNpTt+Oar/090FyJbUo8MYBJuXKLOIfcm6kJIIgsKyo=";

  OPENSSL_NO_VENDOR = 1;

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ openssl hyperscan ];

  meta = with lib; {
    description = "A command-line program that finds secrets and sensitive information in textual data and Git history";
    homepage = "https://github.com/praetorian-inc/noseyparker";
    changelog = "https://github.com/praetorian-inc/noseyparker/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ dit7ya ];
  };
}
