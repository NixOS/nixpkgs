{ rustPlatform, fetchFromGitHub, lib, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "tre-command";
  version = "0.3.6";

  src = fetchFromGitHub {
    owner = "dduan";
    repo = "tre";
    rev = "v${version}";
    sha256 = "1r84xzv3p0ml3wac2j7j5fkm7i93v2xvadb8f8al5wi57q39irj7";
  };

  cargoSha256 = "1nbfgz7njc10b0abs6zwi6wzhlwllps3wah6abc1mj5yhrzwccmh";

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
