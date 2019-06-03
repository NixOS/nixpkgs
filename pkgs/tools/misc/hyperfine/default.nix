{ stdenv, fetchFromGitHub, rustPlatform
, Security
}:

rustPlatform.buildRustPackage rec {
  name = "hyperfine-${version}";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner  = "sharkdp";
    repo   = "hyperfine";
    rev    = "refs/tags/v${version}";
    sha256 = "1mn5nv3zljj2wz40imf62gknv84f7igslsf59gg1qvhgvgsd98sp";
  };

  cargoSha256 = "138m29nl65rg3gx2wkx0jj7p8i2csh9kq03v4arp3mnbglp4802y";

  buildInputs = stdenv.lib.optional stdenv.isDarwin Security;

  meta = with stdenv.lib; {
    description = "Command-line benchmarking tool";
    homepage    = https://github.com/sharkdp/hyperfine;
    license     = with licenses; [ asl20 /* or */ mit ];
    maintainers = [ maintainers.thoughtpolice ];
    platforms   = platforms.all;
  };
}
