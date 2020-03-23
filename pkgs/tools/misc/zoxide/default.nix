{ stdenv, fetchFromGitHub, rustPlatform, fzf }:

rustPlatform.buildRustPackage rec {
  pname = "zoxide";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "ajeetdsouza";
    repo = "zoxide";
    rev = "v${version}";
    sha256 = "0s6aax6bln9jmmv7kw630mj0l6qpvdx8mdk3a5d9akr9d23zxmr5";
  };

  buildInputs = [
    fzf
  ];

  cargoSha256 = "1gzpkf7phl5xd666l7pc25917x4qq0kkxk4i9dkz3lvxz3v8ylrz";

  meta = with stdenv.lib; {
    description = "A fast cd command that learns your habits";
    homepage = "https://github.com/ajeetdsouza/zoxide";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ ysndr cole-h ];
    platforms = platforms.all;
  };
}
