{ stdenv
, lib
, rustPlatform
, fetchFromGitHub
, perl, pkgconfig, openssl, Security, libiconv, curl
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-deny";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "EmbarkStudios";
    repo = pname;
    rev = version;
    sha256 = "1qkg689ks4i665vk3qzyab1y955z5fshp2c6f0zjp618g84sd4ki";
  };

  cargoSha256 = "0nm6xy0nvv2nw6kkdbqq07ix48yd1vvkd06zmffh7gavw40lha9n";

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

