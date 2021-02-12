{ lib, rustPlatform, fetchFromGitLab, pkg-config, openssl }:

rustPlatform.buildRustPackage rec {
  pname = "scaff";
  version = "0.1.2";

  src = fetchFromGitLab {
    owner = "jD91mZM2";
    repo = pname;
    rev = version;

    sha256 = "01yf2clf156qv2a6w866a2p8rc2dl8innxnsqrj244x54s1pk27r";
  };

  cargoSha256 = "1pddjfzbg5xwwj3mjff8ns4jlj7imw0884p47ck2flcv05zjhgi9";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  meta = with lib; {
    description = "Painless and powerful scaffolding of projects";
    license = licenses.mit;
    maintainers = with maintainers; [ jD91mZM2 ];
    platforms = platforms.unix;
  };
}
