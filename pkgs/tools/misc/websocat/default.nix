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
  # Delete this on next update; see #79975 for details
  legacyCargoFetcher = true;

  cargoSha256 = "163kwpahrbb9v88kjkrc0jx2np3c068pspr8rqrm9cb8jyl2njrr";

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
