{ lib, fetchFromGitHub, python3, bcc }:

python3.pkgs.buildPythonApplication rec {
  pname = "sockdump";
  version = "unstable-2022-05-27";

  src = fetchFromGitHub {
    owner = "mechpen";
    repo = pname;
    rev = "4bb689933f253d4f58c8bb81b992cc883068e873";
    hash = "sha256-B2ob4k29kgPA4JMtwr0Ma7vQeDRHL/vTFAJxhdS8ShA=";
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
