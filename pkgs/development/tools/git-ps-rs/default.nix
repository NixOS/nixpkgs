{ lib
, fetchFromGitHub
, rustPlatform
, stdenv
, pkg-config
, dbus
, openssl
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "git-ps-rs";
  version = "7.0.0";

  src = fetchFromGitHub {
    owner = "uptech";
    repo = "git-ps-rs";
    rev = version;
    hash = "sha256-HPHFjYfug642NXeNmv50UzsdOAlDR9F/MtgYnzwiZP8=";
  };

  cargoHash = "sha256-mvRcOwCe5NQ+cJ9brnbZ6HLtLn+fnjYzSBQwA3Qn9PU=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl dbus ] ++ lib.optionals stdenv.isDarwin [ Security ];

  meta = with lib; {
    description = "Tool for working with a stack of patches";
    homepage = "https://git-ps.sh/";
    license = licenses.mit;
    maintainers = with maintainers; [ alizter ];
  };
}
