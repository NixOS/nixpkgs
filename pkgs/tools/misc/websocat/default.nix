{ stdenv, fetchFromGitHub, rustPlatform, Security
}:

rustPlatform.buildRustPackage rec {
  name = "websocat-${version}";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner  = "vi";
    repo   = "websocat";
    rev    = "v${version}";
    sha256 = "1gf2snr12vnx2mhsrwkb5274r1pvdrf8m3bybrqbh8s9wd83nrh6";
  };

  cargoSha256 = "0vkb3jmyb3zg3xiig5vlxhh74m27rvqbkgrwdqzprifn9vcj17ir";

  buildInputs = stdenv.lib.optional stdenv.isDarwin Security;

  meta = with stdenv.lib; {
    description = "Command-line client for WebSockets (like netcat/socat)";
    homepage    = https://github.com/vi/websocat;
    license     = with licenses; [ mit ];
    maintainers = [ maintainers.thoughtpolice ];
    platforms   = platforms.all;
  };
}
