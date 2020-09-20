{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
   pname = "microserver";
   version = "0.1.8";

  src = fetchFromGitHub {
    owner = "robertohuertasm";
    repo = "microserver";
    rev = "v${version}";
    sha256 = "1i9689ra5jnmhkxabrx4zcp5f422w9ql9m4xzldqwmpnckm736v6";
  };

  cargoSha256 = "1yn3xmmhpixiviayicl2szlzfjx5crffp3pq75d5nz6ky3miai9l";

  meta = with stdenv.lib; {
    homepage = "https://github.com/robertohuertasm/microserver";
    description = "Simple ad-hoc server with SPA support";
    maintainers = with maintainers; [ flosse ];
    license = licenses.mit;
  };
}
