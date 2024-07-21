{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "spicy";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "trhodeos";
    repo = "spicy";
    rev = "v${version}";
    sha256 = "sha256-TodMm4UbnLB+LiyfPVXT7bcVLbyBFbGoOYQSsz3IMfM=";
  };

  vendorHash = "sha256-uy33vfsvyLCep1aN8qO0BMmpPylhzTLhosjjD5ghmHE=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Nintendo 64 segment assembler";
    longDescription = ''
      An open-source version of the Nintendo64 sdk's mild.exe. Assembles
      segments into an n64-compatible rom.
    '';
    homepage = "https://github.com/trhodeos/spicy";
    license = licenses.mit;
    maintainers = with maintainers; [ _414owen ];
  };
}
