{ stdenv
, lib
, rustPlatform
, fetchFromGitHub
, perl, pkg-config, openssl, Security, libiconv, curl
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-deny";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "EmbarkStudios";
    repo = pname;
    rev = version;
    sha256 = "sha256-v7Gdemn0IeO6lOg/kT6VKuL5ZSOqA9A721Wv5QStO2Q=";
  };

  cargoSha256 = "sha256-SF7LfxmUMX7f+9BmYTzdjTFplXj5j0e181yRVTIEGH4=";

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

