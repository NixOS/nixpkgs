{ stdenv
, lib
, rustPlatform
, fetchFromGitHub
, perl, pkgconfig, openssl, Security, libiconv, curl
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-deny";
  version = "0.8.4";

  src = fetchFromGitHub {
    owner = "EmbarkStudios";
    repo = pname;
    rev = version;
    sha256 = "18l3nl7db8s8c5yjr5n63qw49bl4qvbzcx1y3vdawfr5fvxj3535";
  };

  cargoSha256 = "00hqxr97lpz1999dkhain0np5yn42mqfrp84nasp4vxyvnmqngmx";

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

