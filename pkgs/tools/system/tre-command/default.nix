{ rustPlatform, fetchFromGitHub, lib, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "tre-command";
  version = "0.3.4";

  src = fetchFromGitHub {
    owner = "dduan";
    repo = "tre";
    rev = "v${version}";
    sha256 = "0syvhpnw9c5csxv8c4gdfwif9a9vl4rjkwj4mfglgxk227k1y53q";
  };

  cargoSha256 = "056wlxz8hzky8315rnn65nh7dd2yhx5323y3hq64g6aqj52vd734";

  nativeBuildInputs = [ installShellFiles ];

  preFixup = ''
    installManPage manual/tre.1
  '';

  meta = with lib; {
    description = "Tree command, improved";
    homepage = "https://github.com/dduan/tre";
    license = licenses.mit;
    maintainers = [ maintainers.dduan ];
  };
}
