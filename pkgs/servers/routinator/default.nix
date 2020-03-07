{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "routinator";
  version = "0.6.4";

  src = fetchFromGitHub {
    owner = "NLnetLabs";
    repo = pname;
    rev = "v${version}";
    sha256 = "1hbqvjv9h1aghpyrl03w5f4j8gjy6n9lx83rmpsh5p7yd9ahwmf9";
  };

  cargoSha256 = "1chf1l9jlnhi9cyqpmcz8yfzwzmkn4lfxqhdhclvl8j4b2zvbcgc";

  meta = with stdenv.lib; {
    description = "An RPKI Validator written in Rust";
    homepage = "https://github.com/NLnetLabs/routinator";
    license = licenses.bsd3;
    maintainers = [ maintainers."0x4A6F" ];
    platforms = platforms.linux;
  };
}
