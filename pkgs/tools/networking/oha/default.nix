{ fetchFromGitHub, lib, pkg-config, rustPlatform, stdenv, openssl, Security }:

rustPlatform.buildRustPackage rec {
  pname = "oha";
  version = "0.5.5";

  src = fetchFromGitHub {
    owner = "hatoo";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-NSre4OHzREVM8y9njMkS/whQ0+Ed+R+cLYfRWKmhA98=";
  };

  cargoSha256 = "sha256-GPP2eespnxDQoKZkqoPXEthRKk84szFl0LNTeqJQLNs=";

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
