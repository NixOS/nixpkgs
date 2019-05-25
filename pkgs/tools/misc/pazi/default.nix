{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "pazi";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "euank";
    repo = pname;
    rev = "v${version}";
    sha256 = "12z2vyzmyxfq1krbbrjar7c2gvyq1969v16pb2pm7f4g4k24g0c8";
  };

  cargoSha256 = "1w97jvlamxlxkqpim5iyayhbsqvg3rqds2nxq1fk5imj4hbi3681";

  cargoPatches = [ ./cargo-lock.patch ];

  meta = with stdenv.lib; {
    description = "An autojump \"zap to directory\" helper";
    homepage = https://github.com/euank/pazi;
    license = licenses.gpl3;
    maintainers = with maintainers; [ bbigras ];
  };
}
