{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "async";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "ctbur";
    repo = pname;
    rev = "v${version}";
    sha256 = "19ypflbayi5l0mb8yw7w0a4bq9a3w8nl9jsxapp9m3xggzmsvrxx";
  };

  cargoSha256 = "1qf52xsd15rj8y9w65zyab7akvzry76k1d4gxvxlz7ph3sl7jl3y";

  meta = with stdenv.lib; {
    description = "A tool to parallelize shell commands";
    longDescription = ''
      `async` is a tool to run shell commands in parallel and is designed to be
      able to quickly parallelize shell scripts with minimal changes. It was
      inspired by GNU Parallel, with the main difference being that async
      retains state between commands by running a server in the background.
      '';
    homepage = "https://github.com/ctbur/async";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ minijackson ];
    platforms = platforms.all;
  };
}
