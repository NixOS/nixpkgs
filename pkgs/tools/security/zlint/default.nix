{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "zlint";
  version = "3.4.0";

  src = fetchFromGitHub {
    owner = "zmap";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-l39GdfEKUAw5DQNjx6ZBgfGtengRlUUasm0G07kAA2A=";
  };

  modRoot = "v3";
  vendorHash = "sha256-OiHEyMHuSiWDB/1YRvAhErb1h/rFfXXVcagcP386doc=";
  preBuild = ''
    # not in the go.mod
    rm -rf cmd/genTestCerts
  '';

  # Tests rely on git and we don't have the .git dir because modRoot is in a subdir
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/zmap/zlint/";
    license = licenses.asl20;
    description = "X.509 Certificate Linter focused on Web PKI standards and requirements.";
    maintainers = with maintainers; [ baloo ];
  };
}
