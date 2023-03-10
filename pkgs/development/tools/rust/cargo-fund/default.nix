{ lib, stdenv, fetchFromGitHub, pkg-config, rustPlatform, Security, curl, openssl, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-fund";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "acfoltzer";
    repo = pname;
    rev = version;
    sha256 = "sha256-hUTBDC2XU82jc9TbyCYVKgWxrKG/OIc1a+fEdj5566M=";
  };

  cargoSha256 = "sha256-cU/X+oNTMjUSODkdm+P+vVLmBJlkeQ9WTJGvQmUOQKw=";

  # The tests need a GitHub API token.
  doCheck = false;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [ Security libiconv curl ];

  meta = with lib; {
    description = "Discover funding links for your project's dependencies";
    homepage = "https://github.com/acfoltzer/cargo-fund";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ johntitor ];
  };
}
