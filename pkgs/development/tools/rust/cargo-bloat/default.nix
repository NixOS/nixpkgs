{ stdenv, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-bloat";
  version = "0.6.4";

  src = fetchFromGitHub {
    owner = "RazrFalcon";
    repo = pname;
    rev = "v${version}";
    sha256 = "041n4kj8kym9hcjc32m4b7nxfqnmzlyy5gfzjblx4nbg151hy945";
  };

  cargoSha256 = "1275jfzkpkzbwv927hdkv4zplmynwrm7sbirq18dwfss55cm7r7z";

  meta = with stdenv.lib; {
    description = "A tool and Cargo subcommand that helps you find out what takes most of the space in your executable";
    homepage = https://github.com/RazrFalcon/cargo-bloat;
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ xrelkd ];
  };
}

