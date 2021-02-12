{ lib, stdenv, fetchFromGitHub, rustPlatform, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "pazi";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "euank";
    repo = pname;
    rev = "v${version}";
    sha256 = "0z8x70mwg0mvz6iap92gil37d4kpg5dizlyfx3zk7984ynycgap8";
  };

  buildInputs = lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Security ];

  cargoSha256 = "1vgpbcnwlnrx8saqxsz40bkf9qam7glvw9vbhd3x7715sxl350iy";

  meta = with lib; {
    description = "An autojump \"zap to directory\" helper";
    homepage = "https://github.com/euank/pazi";
    license = licenses.gpl3;
    maintainers = with maintainers; [ bbigras ];
  };
}
