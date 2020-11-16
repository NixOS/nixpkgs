{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "gping";
  version = "0.1.6";

  src = fetchFromGitHub {
    owner = "orf";
    repo = "gping";
    rev = "v${version}";
    sha256 = "1scwwrrj30ff9yr776gpn4jyl3lbrx2s2dv0pc8b1zj7mvwp3as2";
  };

  cargoSha256 = "1dsfrl5cajl9nmzl6p43j7j50xn1z7dymqaz8kqs7zalj9zadm8k";

  meta = with lib; {
    description = "Ping, but with a graph";
    homepage = "https://github.com/orf/gping";
    license = licenses.mit;
    maintainers = with maintainers; [ andrew-d ];
  };
}
