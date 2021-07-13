{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-modules";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "regexident";
    repo = pname;
    rev = version;
    sha256 = "0y6ag8nar85l2fh2ca41fglkzc74cv1p5szxrhk1jdqnd2qzhvjp";
  };

  cargoSha256 = "0m5r36p57w4vw2g3hg12s38ay328swjb0qfl381xwb2xqx10g8kx";

  meta = with lib; {
    description = "A cargo plugin for showing a tree-like overview of a crate's modules";
    homepage = "https://github.com/regexident/cargo-modules";
    license = with licenses; [ mpl20 ];
    maintainers = with maintainers; [ rvarago ];
  };
}
