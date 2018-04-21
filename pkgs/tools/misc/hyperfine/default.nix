{ stdenv, fetchFromGitHub, rustPlatform }:

with rustPlatform;

buildRustPackage rec {
  name = "hyperfine-${version}";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner  = "sharkdp";
    repo   = "hyperfine";
    rev    = "refs/tags/v${version}";
    sha256 = "0prmnhyp20w71l3mjqgdr38q94cqr1xayzgj7ibbq2hdick4w5nn";
  };

  cargoSha256 = "0saf0hl21ba2ckqbsw64908nvs0x1rjrnm73ackzpmv5pi9j567s";

  meta = with stdenv.lib; {
    description = "Command-line benchmarking tool";
    homepage    = https://github.com/sharkdp/hyperfine;
    license     = with licenses; [ asl20 /* or */ mit ];
    maintainers = [ maintainers.thoughtpolice ];
    platforms   = platforms.all;
  };
}
