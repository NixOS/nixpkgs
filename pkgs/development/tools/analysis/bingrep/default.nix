{ stdenv, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "bingrep";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "m4b";
    repo = pname;
    # Currently doesn't tag versions so we're using the raw revision
    rev = "33d56a4b020c4a3c111294fe41c613d5e8e9c7af";
    sha256 = "0lg92wqknr584b44i5v4f97js56j89z7n8p2zpm8j1pfhjmgcigs";
  };

  cargoSha256 = "1yxm7waldhilx7wh1ag79rkp8kypb9k1px4ynmzq11r72yl2p4m7";

  meta = with stdenv.lib; {
    description = "Greps through binaries from various OSs and architectures, and colors them";
    homepage = "https://github.com/m4b/bingrep";
    license = licenses.mit;
    maintainers = with maintainers; [ minijackson ];
  };
}
