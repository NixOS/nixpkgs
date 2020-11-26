{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
   pname = "microserver";
   version = "0.2.0";

  src = fetchFromGitHub {
    owner = "robertohuertasm";
    repo = "microserver";
    rev = "v${version}";
    sha256 = "1bbbdajh74wh2fbidasim2mzmzqjrgi02v8b0g7vbhpdnlim6ixz";
  };

  cargoSha256 = "0cyxa200iz7knkma4zi3mzky3g0kibbxd5303psk2rl2rppir0f7";

  meta = with stdenv.lib; {
    homepage = "https://github.com/robertohuertasm/microserver";
    description = "Simple ad-hoc server with SPA support";
    maintainers = with maintainers; [ flosse ];
    license = licenses.mit;
  };
}
