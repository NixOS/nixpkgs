{ stdenv, fetchFromGitHub, pkgconfig, openssl, rustPlatform, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "websocat";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner  = "vi";
    repo   = "websocat";
    rev    = "v${version}";
    sha256 = "1gf2snr12vnx2mhsrwkb5274r1pvdrf8m3bybrqbh8s9wd83nrh6";
  };

  cargoBuildFlags = [ "--features=ssl" ];
  cargoSha256 = "1zqfvbihf8xwgh092n9wzm3mdgbv0n99gjsfk9przqj2vh7wfvh2";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ openssl ] ++ stdenv.lib.optional stdenv.isDarwin Security;

  meta = with stdenv.lib; {
    description = "Command-line client for WebSockets (like netcat/socat)";
    homepage    = https://github.com/vi/websocat;
    license     = with licenses; [ mit ];
    maintainers = [ maintainers.thoughtpolice ];
    platforms   = platforms.all;
  };
}
