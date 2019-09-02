{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-bloat";
  version = "0.8.3";

  src = fetchFromGitHub {
    owner = "RazrFalcon";
    repo = pname;
    rev = "v${version}";
    sha256 = "088px2kdcfjdb8zfmk7g409h7ij9dngywz336hj2ny82lrdjzazc";
  };

  cargoSha256 = "11q8j8y7m59gc8047qhz6pp2825qjcpg9xwgj09l8a5aijf25avb";

  meta = with lib; {
    description = "A tool and Cargo subcommand that helps you find out what takes most of the space in your executable";
    homepage = "https://github.com/RazrFalcon/cargo-bloat";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ xrelkd ];
  };
}

