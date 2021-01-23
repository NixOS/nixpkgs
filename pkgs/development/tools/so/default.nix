{ lib, stdenv, rustPlatform, fetchFromGitHub, openssl, pkg-config, libiconv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "so";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "samtay";
    repo = pname;
    rev = "v${version}";
    sha256 = "09zswxxli9f5ayjwmvqhkp1yv2s4f435dcfp4cyia1zddbrh2zck";
  };

  cargoSha256 = "1ddbhy1plag4ckbmlyj47wnky7vgmfa68msl3hl25h1lwmzaf1aq";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [
    libiconv Security
  ];

  meta = with lib; {
    description = "A TUI interface to the StackExchange network";
    homepage = "https://github.com/samtay/so";
    license = licenses.mit;
    maintainers = with maintainers; [ mredaelli ];
  };
}
