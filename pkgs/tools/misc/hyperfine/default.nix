{ stdenv, fetchFromGitHub, rustPlatform }:

with rustPlatform;

buildRustPackage rec {
  name = "hyperfine-${version}";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner  = "sharkdp";
    repo   = "hyperfine";
    rev    = "refs/tags/v${version}";
    sha256 = "1ynqyacbx0x971lyd1k406asms58bc7vzl8gca3sg34rx0hx3wzi";
  };

  cargoSha256 = "109yv1618bi19vh1jjv2ki06mafhcrv35a3a1zsr34kg3gsjv0rb";

  meta = with stdenv.lib; {
    description = "Command-line benchmarking tool";
    homepage    = https://github.com/sharkdp/hyperfine;
    license     = with licenses; [ asl20 /* or */ mit ];
    maintainers = [ maintainers.thoughtpolice ];
    platforms   = platforms.all;
  };
}
