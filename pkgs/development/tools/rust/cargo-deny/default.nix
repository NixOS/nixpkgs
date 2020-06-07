{ stdenv
, lib
, rustPlatform
, fetchFromGitHub
, perl, pkgconfig, openssl, Security, libiconv, curl
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-deny";
  version = "0.6.8";

  src = fetchFromGitHub {
    owner = "EmbarkStudios";
    repo = pname;
    rev = version;
    sha256 = "0nv3min7jyrv4scn7bhizc9vmqhmv6sg0nvfnr0m59pm5806vdpi";
  };

  cargoSha256 = "1vywm3iqs3qnkrvi7i70sv21hznn3y3hza1i9gvcxfmh03wzhwx0";

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

