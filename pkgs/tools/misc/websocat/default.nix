{ stdenv, fetchFromGitHub, pkgconfig, openssl, rustPlatform, Security }:

rustPlatform.buildRustPackage rec {
  pname = "websocat";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "vi";
    repo = "websocat";
    rev = "v${version}";
    sha256 = "1lmra91ahpk4gamhnbdr066hl4vzwfh5i09fbabzdnxcvylbx8zf";
  };

  cargoBuildFlags = [ "--features=ssl" ];
  cargoSha256 = "09chj0bgf4r8v5cjq0hvb84zvh98nrzrh1m0wdqjy5gi7zc30cis";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ openssl ] ++ stdenv.lib.optional stdenv.isDarwin Security;

  meta = with stdenv.lib; {
    description = "Command-line client for WebSockets (like netcat/socat)";
    homepage = "https://github.com/vi/websocat";
    license = licenses.mit;
    maintainers = with maintainers; [ thoughtpolice filalex77 ];
    platforms = platforms.all;
  };
}
