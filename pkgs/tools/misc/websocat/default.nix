{ stdenv, fetchFromGitHub, pkgconfig, openssl, rustPlatform, Security, makeWrapper, bash }:

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

  nativeBuildInputs = [ pkgconfig makeWrapper ];
  buildInputs = [ openssl ] ++ stdenv.lib.optional stdenv.isDarwin Security;

  # The wrapping is required so that the "sh-c" option of websocat works even
  # if sh is not in the PATH (as can happen, for instance, when websocat is
  # started as a systemd service).
  postInstall = ''
    wrapProgram $out/bin/websocat \
      --prefix PATH : ${stdenv.lib.makeBinPath [ bash ]}
  '';

  meta = with stdenv.lib; {
    description = "Command-line client for WebSockets (like netcat/socat)";
    homepage = "https://github.com/vi/websocat";
    license = licenses.mit;
    maintainers = with maintainers; [ thoughtpolice filalex77 ];
    platforms = platforms.all;
  };
}
