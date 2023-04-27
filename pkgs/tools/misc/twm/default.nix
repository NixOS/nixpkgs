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
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "vinnymeller";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-H9Ek0F+Vu55y18FMJphbsh9YmsEt9V0+nP7Qv4oHKQs=";
  };

  cargoHash = "sha256-i81srCXC8Es6GUn6dStKq5Vg20BLVxf5XUObUUbZfr8=";

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
