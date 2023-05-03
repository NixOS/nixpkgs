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
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "vinnymeller";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-YURzNHbmGLEqNEcc4FImIqn/KcRwGdxYXM5QzM3dxbo=";
  };

  cargoHash = "sha256-sc2/eQZjY1x5KIzQ+yr8NgAMKJ6iHWwCy6fRSBp7Fw4=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [ Security ];

  meta = with lib; {
    description = "A customizable workspace manager for tmux";
    homepage = "https://github.com/vinnymeller/twm";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ vinnymeller ];
  };
}
