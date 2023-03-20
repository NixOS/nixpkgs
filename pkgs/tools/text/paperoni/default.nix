{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "paperoni";
  version = "0.6.1-alpha1";

  src = fetchFromGitHub {
    owner = "hipstermojo";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-vTylnDtoPpiRtk/vew1hLq3g8pepWRVqBEBnvSif4Zw=";
  };

  cargoSha256 = "sha256-iLEIGuVB9ykNcwbXk/donDdBuMvitM54Ax6bszVGaO0=";

  nativeBuildInputs = lib.optionals stdenv.isLinux [ pkg-config ];

  buildInputs = lib.optionals stdenv.isLinux [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ Security ];

  meta = with lib; {
    description = "An article extractor in Rust";
    homepage = "https://github.com/hipstermojo/paperoni";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
