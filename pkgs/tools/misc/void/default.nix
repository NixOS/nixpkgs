{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  name = "void-${version}";
  version = "1.1.5";

  src = fetchFromGitHub {
    owner = "spacejam";
    repo = "void";
    rev = "${version}";
    sha256 = "08vazw4rszqscjz988k89z28skyj3grm81bm5iwknxxagmrb20fz";
  };

  # The tests are long-running and not that useful
  doCheck = false;

  cargoSha256 = "1rq947s82icl7gdkjynjwz426bpmd96dip2dv2y7p8rg7yz29x0m";

  meta = with stdenv.lib; {
    description = "Terminal-based personal organizer";
    homepage = https://github.com/spacejam/void;
    license = licenses.gpl3;
    maintainers = with maintainers; [ spacekookie ];
    platforms = platforms.all;
  };
}
