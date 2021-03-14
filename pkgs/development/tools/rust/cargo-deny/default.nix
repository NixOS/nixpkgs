{ stdenv
, lib
, rustPlatform
, fetchFromGitHub
, perl, pkg-config, openssl, Security, libiconv, curl
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-deny";
  version = "0.8.8";

  src = fetchFromGitHub {
    owner = "EmbarkStudios";
    repo = pname;
    rev = version;
    sha256 = "sha256-8wmH9DeI+tm3c/6n7bwMe5SslGNCUg4d5BE0+wQ7KTU=";
  };

  cargoSha256 = "sha256-f0Wisel7NQOyfbhhs0GwyTBiUfydPMSVAysrov/RxxI=";

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

