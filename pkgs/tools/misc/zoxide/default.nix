{ lib
, fetchFromGitHub
, rustPlatform
, fzf
}:

rustPlatform.buildRustPackage rec {
  pname = "zoxide";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "ajeetdsouza";
    repo = "zoxide";
    rev = "v${version}";
    sha256 = "1qkvmjrkcivfzbm6swl5lgvpqz9av9jxcn9i8ms3wz4vfsibmlxv";
  };

  buildInputs = [
    fzf
  ];

  cargoSha256 = "1w921f7b6kzc1mjzff1bcs3mg4cp9h48698w2zlv5jzjs7nwgb8n";

  meta = with lib; {
    description = "A fast cd command that learns your habits";
    homepage = "https://github.com/ajeetdsouza/zoxide";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ ysndr cole-h ];
    platforms = platforms.all;
  };
}
