{ lib, fetchFromGitHub, python3, bcc }:

python3.pkgs.buildPythonApplication rec {
  pname = "sockdump";
  version = "unstable-2023-09-16";

  src = fetchFromGitHub {
    owner = "mechpen";
    repo = pname;
    rev = "713759e383366feae76863881e851a6411c73b68";
    hash = "sha256-q6jdwFhl2G9o2C0BVU6Xz7xizO00yaSQ2KSR/z4fixY=";
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
