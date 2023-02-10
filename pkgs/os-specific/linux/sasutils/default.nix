{ lib, python3Packages, fetchFromGitHub, installShellFiles, sg3_utils }:

python3Packages.buildPythonApplication rec {
  pname = "sasutils";
  version = "0.3.13";

  src = fetchFromGitHub {
    owner = "stanford-rc";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-cPCmmJkhr4+STVHa7e3LZGZFd8KPkECMAVurhuG8H1s=";
  };

  nativeBuildInputs = [ installShellFiles ];

  propagatedBuildInputs = [ sg3_utils ];

  postInstall = ''
    installManPage doc/man/man1/*.1
  '';

  meta = with lib; {
    homepage = "https://github.com/stanford-rc/sasutils";
    description = "A set of command-line tools to ease the administration of Serial Attached SCSI (SAS) fabrics";
    license = licenses.asl20;
    maintainers = with maintainers; [ aij ];
  };
}
