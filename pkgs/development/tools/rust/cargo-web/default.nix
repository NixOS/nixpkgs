{ lib, stdenv, fetchFromGitHub, openssl, perl, pkg-config, rustPlatform
, CoreServices, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-web";
  version = "0.6.26";

  src = fetchFromGitHub {
    owner = "koute";
    repo = pname;
    rev = version;
    sha256 = "1dl5brj5fnmxmwl130v36lvy4j64igdpdvjwmxw3jgg2c6r6b7cd";
  };

  cargoHash = "sha256-apPXSG8RV9hZ+jttn4XHhgmuLQ7344SQJna7Z/fu/mA=";

  nativeBuildInputs = [ openssl perl pkg-config ];
  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ CoreServices Security ];

  meta = with lib; {
    description = "Cargo subcommand for the client-side Web";
    mainProgram = "cargo-web";
    homepage = "https://github.com/koute/cargo-web";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ kevincox ];
  };
}
