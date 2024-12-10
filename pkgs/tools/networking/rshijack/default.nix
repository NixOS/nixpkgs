{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "rshijack";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "kpcyrd";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-UyrHMw+3JE4zR+N7rdcTkLP3m4h6txkYa8uG9r7S9ZE=";
  };

  cargoHash = "sha256-bGGbZ3JXeo6eytiDHrgHOQN3VgfaqtWssz5hY0RZoZ0=";

  meta = with lib; {
    description = "TCP connection hijacker";
    homepage = "https://github.com/kpcyrd/rshijack";
    license = licenses.gpl3;
    maintainers = with maintainers; [ xrelkd ];
    platforms = platforms.unix;
    mainProgram = "rshijack";
  };
}
