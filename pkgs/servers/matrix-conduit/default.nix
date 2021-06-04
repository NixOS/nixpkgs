{ stdenv, lib, fetchFromGitLab, rustPlatform, }:

rustPlatform.buildRustPackage rec {

  pname = "matrix-conduit";
  version = "unstable-2021-05-28";

  src = fetchFromGitLab {
    owner = "famedly";
    repo = "conduit";
    rev = "bff68e595bc9c7dcfae46db47f55aa1ad822206f";
    sha256 = "1z73w5q4hayji8q5yqls1yyk7iff1anyl314smy005f5p2a7q56d";
  };

  cargoSha256 = "1qzg67ljin5g7cfjl6yc4c3sbvscwv9fy5wvdiyr1ksnn3c4v05v";

  meta = with lib; {
    description = "A Matrix homeserver written in Rust";
    homepage = "https://conduit.rs/";
    license = licenses.asl20;
    maintainers = with maintainers; [ pstn piegames ];
  };
}
