{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-bloat";
  version = "0.9.3";

  src = fetchFromGitHub {
    owner = "RazrFalcon";
    repo = pname;
    rev = "v${version}";
    sha256 = "04h9yyna47cgn2d232v2fpbgki9gg4lykpmx46ncpsq4g6azl1a9";
  };

  cargoSha256 = "0lzc2nwz9lpwxv704k40d1416qnf3wy3g6ad8w8xbkfc6ydcaa4l";

  meta = with lib; {
    description = "A tool and Cargo subcommand that helps you find out what takes most of the space in your executable";
    homepage = "https://github.com/RazrFalcon/cargo-bloat";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ xrelkd ];
  };
}

