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

  cargoSha256 = "0mgjl5vazk5z1859lb2va9af9yivz47jw4b01rjr4mq67v9jfld1";

  cargoPatches = [ ./cargo-lock.patch ];

  meta = with stdenv.lib; {
    description = "An autojump \"zap to directory\" helper";
    homepage = https://github.com/euank/pazi;
    license = licenses.gpl3;
    maintainers = with maintainers; [ bbigras ];
  };
}
