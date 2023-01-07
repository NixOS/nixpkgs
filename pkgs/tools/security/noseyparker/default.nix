{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, cmake
, pkg-config
, openssl
, hyperscan
}:

rustPlatform.buildRustPackage rec {
  pname = "noseyparker";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "praetorian-inc";
    repo = "noseyparker";
    rev = "v${version}";
    sha256 = "sha256-7hDrHYxVKduQl3kpLUHEXDPKTz1B74GjxKC5XEPYEmc=";
  };

  cargoSha256 = "sha256-JNpTt+Oar/090FyJbUo8MYBJuXKLOIfcm6kJIIgsKyo=";

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    openssl
    hyperscan
  ];

  OPENSSL_NO_VENDOR = 1;

  meta = with lib; {
    description = "Find secrets and sensitive information in textual data";
    homepage = "https://github.com/praetorian-inc/noseyparker";
    changelog = "https://github.com/praetorian-inc/noseyparker/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ _0x4A6F ];
    # limited by hyperscan
    platforms = [ "x86_64-linux" ];
  };
}
