{ lib, rustPlatform, fetchFromGitHub, ncurses, openssl, pkg-config, stdenv, Security, fetchpatch }:

rustPlatform.buildRustPackage rec {
  pname = "wiki-tui";
  version = "0.4.8";

  src = fetchFromGitHub {
    owner = "Builditluc";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-/u0segKHrrtXfEjOmpnQ/iFbsM+VfsZKTpyc1IfuOU8=";
  };

  buildInputs = [ ncurses openssl ] ++ lib.optional stdenv.isDarwin Security;

  nativeBuildInputs = [ pkg-config ];

  cargoSha256 = "sha256-3xvaEzqAz/U8CkdGYXLBnxrgW1raeKuzRsmD+0Sd4iQ=";

  # Tests fail with this error: `found argument --test-threads which was not expected`
  doCheck = false;

  meta = with lib; {
    description = "A simple and easy to use Wikipedia Text User Interface";
    homepage = "https://github.com/builditluc/wiki-tui";
    license = licenses.mit;
    maintainers = with maintainers; [ lom builditluc ];
  };
}
