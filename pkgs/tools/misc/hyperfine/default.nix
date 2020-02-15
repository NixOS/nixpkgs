{ stdenv, fetchFromGitHub, rustPlatform
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "hyperfine";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner  = "sharkdp";
    repo   = pname;
    rev    = "refs/tags/v${version}";
    sha256 = "0jx2lqhayp14c51dfvgmqrmmadyvxf0p4dsn770ndqpzv66rh6zb";
  };

  cargoSha256 = "0n0hizldhr026mrzzz1wlw4g0b1z6ybxarybq3fzchs722iqpsis";

  buildInputs = stdenv.lib.optional stdenv.isDarwin Security;

  meta = with stdenv.lib; {
    description = "Command-line benchmarking tool";
    homepage    = "https://github.com/sharkdp/hyperfine";
    license     = with licenses; [ asl20 /* or */ mit ];
    maintainers = [ maintainers.thoughtpolice ];
    platforms   = platforms.all;
  };
}
