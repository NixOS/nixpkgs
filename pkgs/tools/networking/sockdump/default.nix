{ lib, fetchFromGitHub, python3, bcc }:

python3.pkgs.buildPythonApplication rec {
  pname = "sockdump";
  version = "unstable-2022-10-12";

  src = fetchFromGitHub {
    owner = "mechpen";
    repo = pname;
    rev = "005dcb056238c2e37ff378aef27c953208ffa08f";
    hash = "sha256-X8PIUDxlcdPoD7+aLDWzlWV++P3mmu52BwY7irhypww=";
  };

  propagatedBuildInputs = [ bcc ];

  format = "other"; # none

  installPhase = "install -D ${pname}.py $out/bin/${pname}";

  meta = src.meta // {
    description = "Dump unix domain socket traffic with bpf";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ ehmry ];
  };
}
