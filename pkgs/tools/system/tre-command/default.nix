{ rustPlatform, fetchFromGitHub, stdenv, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "tre-command";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "dduan";
    repo = "tre";
    rev = "v${version}";
    sha256 = "1kb8jwmjhlp9bk08rb6gq3j810cv9bidm28sa417vyykp9a8p2ky";
  };

  cargoSha256 = "0cqkpvq8b2vnqpkd819cdgh4fqr9yns337fgzah4m40ygs25n9iv";

  nativeBuildInputs = [ installShellFiles ];

  preFixup = ''
    installManPage manual/tre.1
  '';

  meta = with stdenv.lib; {
    description = "Tree command, improved";
    homepage = "https://github.com/dduan/tre";
    license = licenses.mit;
    maintainers = [ maintainers.dduan ];
  };
}
