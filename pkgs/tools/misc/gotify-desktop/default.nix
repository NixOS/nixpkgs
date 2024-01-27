{ lib, fetchFromGitHub, rustPlatform, openssl, pkg-config, stdenv}:

rustPlatform.buildRustPackage rec {
  pname = "gotify-desktop";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "desbma";
    repo = pname;
    rev = version;
    sha256 = "sha256-aJBgvgDG3PIogTP7jZtncKeXc7NAnJdtjpBOk303wzs=";
  };

  cargoHash = "sha256-JJlTS22XveuLd53ck7zduQVvEk1E/yOGkBSTvDf/XEQ=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  meta = with lib; {
    description = "Small Gotify daemon to send messages as desktop notifications";
    homepage = "https://github.com/desbma/gotify-desktop";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ bryanasdev000 genofire ];
    broken = stdenv.isDarwin;
    mainProgram = "gotify-desktop";
  };
}
