{ lib, stdenv, fetchFromGitHub, pkg-config, openssl, rustPlatform, Security, makeWrapper, bash }:

rustPlatform.buildRustPackage rec {
  pname = "websocat";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "vi";
    repo = "websocat";
    rev = "v${version}";
    sha256 = "0iilq96bxcb2fsljvlgy47pg514w0jf72ckz39yy3k0gwc1yfcja";
  };

  cargoBuildFlags = [ "--features=ssl" ];
  cargoSha256 = "1k5nvh2adlrifvkppc0bir34y2j2i2hrxsj9gawshy27k8s9yfq8";

  nativeBuildInputs = [ pkg-config makeWrapper ];
  buildInputs = [ openssl ] ++ lib.optional stdenv.isDarwin Security;

  # The wrapping is required so that the "sh-c" option of websocat works even
  # if sh is not in the PATH (as can happen, for instance, when websocat is
  # started as a systemd service).
  postInstall = ''
    wrapProgram $out/bin/websocat \
      --prefix PATH : ${lib.makeBinPath [ bash ]}
  '';

  meta = with lib; {
    description = "Command-line client for WebSockets (like netcat/socat)";
    homepage = "https://github.com/vi/websocat";
    license = licenses.mit;
    maintainers = with maintainers; [ thoughtpolice Br1ght0ne ];
  };
}
