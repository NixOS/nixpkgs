{ rustPlatform, fetchFromGitHub, lib, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "tre-command";
  version = "0.3.5";

  src = fetchFromGitHub {
    owner = "dduan";
    repo = "tre";
    rev = "v${version}";
    sha256 = "1yhrawn8xdl84f5f56i8fikidrfbjnqw5ckjagk7f6ngpcjc0wxm";
  };

  cargoSha256 = "03zvykjmb61bn8h4pm93iayhw1d53qv3l635jxfii1q7kzjbdnx9";

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
