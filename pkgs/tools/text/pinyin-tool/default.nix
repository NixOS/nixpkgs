{ stdenv, lib, rustPlatform, fetchFromGitHub, Security }:

rustPlatform.buildRustPackage rec {
  pname = "pinyin-tool";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "briankung";
    repo = pname;
    rev = version;
    sha256 = "1gwqwxlvdrm4sdyqkvpvvfi6jh6qqn6qybn0z66wm06k62f8zj5b";
  };

  cargoSha256 = "1ixl4bsb8c8dmz9s28a2v5l5f2hi3g9xjy6ribmhybpwmfs4mr4d";

  buildInputs = lib.optionals stdenv.isDarwin [ Security ];

  meta = with lib; {
    description = "A simple command line tool for converting Chinese characters to space-separate pinyin words";
    mainProgram = "pinyin-tool";
    homepage = "https://github.com/briankung/pinyin-tool";
    license = licenses.mit;
    maintainers = with maintainers; [ neonfuz ];
  };
}
