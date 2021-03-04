{ stdenv
, lib
, rustPlatform
, fetchFromGitHub
, perl, pkg-config, openssl, Security, libiconv, curl
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-deny";
  version = "0.8.7";

  src = fetchFromGitHub {
    owner = "EmbarkStudios";
    repo = pname;
    rev = version;
    sha256 = "sha256-LXc4PFJ1FbdF3yotqqOkhhe+MKGZ4sqJgxAvDml9GeA=";
  };

  cargoSha256 = "sha256-4FFyRhmMpzKmKrvU2bmGHWUnLAbTDU1bPv7RfhQfYeY=";

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

