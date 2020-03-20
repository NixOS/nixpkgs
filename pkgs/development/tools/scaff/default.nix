{ lib, rustPlatform, fetchFromGitLab, pkgconfig, openssl }:

rustPlatform.buildRustPackage rec {
  pname = "scaff";
  version = "0.1.2";

  src = fetchFromGitLab {
    owner = "jD91mZM2";
    repo = pname;
    rev = version;

    sha256 = "01yf2clf156qv2a6w866a2p8rc2dl8innxnsqrj244x54s1pk27r";
  };

  cargoSha256 = "1v6580mj70d7cqbjw32slz65lg6c8ficq5mdkfbivs63hqkv4hgx";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ openssl ];

  meta = with lib; {
    description = "Painless and powerful scaffolding of projects";
    license = licenses.mit;
    maintainers = with maintainers; [ jD91mZM2 ];
    platforms = platforms.unix;
  };
}
