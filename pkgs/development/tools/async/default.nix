{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "async";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "ctbur";
    repo = pname;
    rev = "v${version}";
    sha256 = "19ypflbayi5l0mb8yw7w0a4bq9a3w8nl9jsxapp9m3xggzmsvrxx";
  };

  cargoSha256 = "0y2q46i838gha58p95vcv5r5i14il1kv86k35s30ncfibijgp0lc";

  meta = with lib; {
    description = "Tool to parallelize shell commands";
    mainProgram = "async";
    longDescription = ''
      `async` is a tool to run shell commands in parallel and is designed to be
      able to quickly parallelize shell scripts with minimal changes. It was
      inspired by GNU Parallel, with the main difference being that async
      retains state between commands by running a server in the background.
      '';
    homepage = "https://github.com/ctbur/async";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ minijackson ];
  };
}
