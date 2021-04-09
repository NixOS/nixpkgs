{ stdenv
, lib
, rustPlatform
, fetchFromGitHub
, perl, pkg-config, openssl, Security, libiconv, curl
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-deny";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "EmbarkStudios";
    repo = pname;
    rev = version;
    sha256 = "sha256-ZjXAZN93ij42WVYSOgvKAzFZ/cZ2RTFKT2sr44j7TVc=";
  };

  cargoSha256 = "sha256-eQv9pFegHTjjjFURiD/yN/srtONAwAH3vwfrSY/LM/Q=";

  doCheck = false;

  nativeBuildInputs = [ perl pkg-config ];

  buildInputs = [ openssl  ]
    ++ lib.optionals stdenv.isDarwin [ Security libiconv curl ];

  meta = with lib; {
    description = "Cargo plugin to generate list of all licenses for a crate";
    homepage = "https://github.com/EmbarkStudios/cargo-deny";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}

