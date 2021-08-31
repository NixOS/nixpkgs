{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "difftastic";
  version = "0.6";

  src = fetchFromGitHub {
    owner = "wilfred";
    repo = pname;
    rev = version;
    sha256 = "WFvxdRCbTBW1RGn2SvAo2iXn82OO/Z06cZQkIu4eiew=";
  };

  cargoSha256 = "2hRUfIxNVs4uSrEESas3wvvVsZHVocP8aiO7K0NZ+mY=";

  meta = with lib; {
    description = "A syntax-aware diff";
    homepage = "https://github.com/Wilfred/difftastic";
    license = licenses.mit;
    maintainers = with maintainers; [ ethancedwards8 ];
    platforms = platforms.unix;
  };
}
