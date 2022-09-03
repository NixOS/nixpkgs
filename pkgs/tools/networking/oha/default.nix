{ fetchFromGitHub, lib, pkg-config, rustPlatform, stdenv, openssl, Security }:

rustPlatform.buildRustPackage rec {
  pname = "oha";
  version = "0.5.4";

  src = fetchFromGitHub {
    owner = "hatoo";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-dk9OXUt31UIZLH3E50R8iE8zJqvdT1pBu1oU25QrOro=";
  };

  cargoSha256 = "sha256-WlAAuFz7DZ4PhlTgEXNK9sZKkS95pCrbX2AXC3c1rh8=";

  nativeBuildInputs = lib.optional stdenv.isLinux pkg-config;

  buildInputs = lib.optional stdenv.isLinux openssl
    ++ lib.optional stdenv.isDarwin Security;

  # remove cargo config so it can find the linker
  postPatch = ''
    rm .cargo/config.toml
  '';

  # tests don't work inside the sandbox
  doCheck = false;

  meta = with lib; {
    description = "HTTP load generator inspired by rakyll/hey with tui animation";
    homepage = "https://github.com/hatoo/oha";
    changelog = "https://github.com/hatoo/oha/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
