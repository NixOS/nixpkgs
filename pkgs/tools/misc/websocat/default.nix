{ lib, stdenv, fetchFromGitHub, pkg-config, openssl, rustPlatform, libiconv
, Security, makeWrapper, bash }:

rustPlatform.buildRustPackage rec {
  pname = "websocat";
  version = "1.12.0";

  src = fetchFromGitHub {
    owner = "vi";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-wyVys+1g2klgwFHlKHI0ztd2qSlWyNXJoFvFCd1PGjo=";
  };

  cargoHash = "sha256-fakXOPQOEaKEt+AeOYlhumULJyjRHHXFKz4o9AD7WE0=";

  nativeBuildInputs = [ pkg-config makeWrapper ];
  buildInputs = [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ libiconv Security ];

  buildFeatures = [ "ssl" ];

  # Needed to get openssl-sys to use pkg-config.
  OPENSSL_NO_VENDOR=1;

  # The wrapping is required so that the "sh-c" option of websocat works even
  # if sh is not in the PATH (as can happen, for instance, when websocat is
  # started as a systemd service).
  postInstall = ''
    wrapProgram $out/bin/websocat \
      --prefix PATH : ${lib.makeBinPath [ bash ]}
  '';

  meta = with lib; {
    homepage = "https://github.com/vi/websocat";
    description = "Command-line client for WebSockets (like netcat/socat)";
    changelog = "https://github.com/vi/websocat/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ thoughtpolice Br1ght0ne ];
  };
}
