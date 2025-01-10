{
  stdenv,
  lib,
  rustPlatform,
  fetchFromGitHub,
  Security,
}:

rustPlatform.buildRustPackage rec {
  pname = "pinyin-tool";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "briankung";
    repo = pname;
    rev = version;
    sha256 = "1gwqwxlvdrm4sdyqkvpvvfi6jh6qqn6qybn0z66wm06k62f8zj5b";
  };

  cargoHash = "sha256-jeRKtKv8Lg/ritl42dMbEQpXaNlCIaHTrw0xtPQitMc=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ Security ];

  meta = with lib; {
    description = "Simple command line tool for converting Chinese characters to space-separate pinyin words";
    mainProgram = "pinyin-tool";
    homepage = "https://github.com/briankung/pinyin-tool";
    license = licenses.mit;
    maintainers = with maintainers; [ neonfuz ];
  };
}
