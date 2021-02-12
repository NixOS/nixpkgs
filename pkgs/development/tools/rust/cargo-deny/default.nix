{ stdenv
, lib
, rustPlatform
, fetchFromGitHub
, perl, pkg-config, openssl, Security, libiconv, curl
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-deny";
  version = "0.8.5";

  src = fetchFromGitHub {
    owner = "EmbarkStudios";
    repo = pname;
    rev = version;
    sha256 = "01czsnhlvs78fpx1kpi75386657jmlrqpsj4474nxmgcs75igncx";
  };

  cargoSha256 = "153pby28vg28pb9i9ilpd75x1wwq9jxcwfdyblx8r9wgandb9xik";

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

