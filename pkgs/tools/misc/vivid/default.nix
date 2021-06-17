{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "vivid";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "sharkdp";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-2rdNjpJrBuj6toLFzFJScNh6od5qUhkSaZF+NbPBlQA=";
  };

  cargoSha256 = "sha256-1aox1eiF3hu5guBjRcM3qb6mHJOutI+yargW7X4cFfg=";

  meta = with lib; {
    description = "A generator for LS_COLORS with support for multiple color themes";
    homepage = "https://github.com/sharkdp/vivid";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = [ maintainers.dtzWill ];
    platforms = platforms.unix;
  };
}
