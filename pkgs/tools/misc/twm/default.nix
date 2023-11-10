{ lib
, fetchFromGitHub
, stdenv
, rustPlatform
, openssl
, pkg-config
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "twm";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "vinnymeller";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-icJQSPt3733H5pIdnpC/Vx+u6LgwokCdbvE3wvDkIlw=";
  };

  cargoHash = "sha256-DxT3Wsiy4zVlTSJwHqV/McSi/pc9pB0wyWY54fj1zVE=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [ Security ];

  meta = with lib; {
    description = "A customizable workspace manager for tmux";
    homepage = "https://github.com/vinnymeller/twm";
    changelog = "https://github.com/vinnymeller/twm/releases/tag/v${version}";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ vinnymeller ];
  };
}
