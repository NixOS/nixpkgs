{ lib
, fetchFromGitHub
, rustPlatform
, fzf
}:

rustPlatform.buildRustPackage rec {
  pname = "zoxide";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "ajeetdsouza";
    repo = "zoxide";
    rev = "v${version}";
    sha256 = "0w4by34chm2baqldxx72bhjz8ggsllpir1df07gxi5fjkmil8jy9";
  };

  buildInputs = [
    fzf
  ];

  cargoSha256 = "19fziapiv5w9wxslw47rf3lgc2lv7dyl3n8py6bsddq41fzay30w";

  meta = with lib; {
    description = "A fast cd command that learns your habits";
    homepage = "https://github.com/ajeetdsouza/zoxide";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ ysndr cole-h ];
    platforms = platforms.all;
  };
}
