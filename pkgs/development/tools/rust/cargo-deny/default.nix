{ stdenv
, lib
, rustPlatform
, fetchFromGitHub
, perl, pkgconfig, openssl, Security, libiconv, curl
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-deny";
  version = "0.6.7";

  src = fetchFromGitHub {
    owner = "EmbarkStudios";
    repo = pname;
    rev = version;
    sha256 = "1d7zd2wpvfz1vq5ik67m6s1mscivh8b3kz4bfckw3cazk68vn9q1";
  };

  cargoSha256 = "0jy10yfd9d5r0ildyxszs1ppzyd4ninl7lihdnwjqm6qifr1m5rp";

  nativeBuildInputs = [ perl pkgconfig ];

  buildInputs = [ openssl  ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ Security libiconv curl ];

  meta = with lib; {
    description = "Cargo plugin to generate list of all licenses for a crate";
    homepage = "https://github.com/EmbarkStudios/cargo-deny";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}

