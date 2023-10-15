{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "auto-epp-go";
  version = "0.1.1-1";

  goPackagePath = "github.com/tfkhdyt/auto-epp-go";

  ldflags = [ "-s" "-w" ];

  src = fetchFromGitHub {
    owner = "tfkhdyt";
    repo = "auto-epp-go";
    rev = "v${version}";
    sha256 = "sha256-AeBdXO5I9etmqSiAak0T9LDrwtAT8fHM/5gHRplrhbM=";
  };

  meta = with lib; {
    mainProgram = "${pname}";
    homepage = "https://github.com/tfkhdyt/auto-epp-go";
    description =
      "Auto-epp for amd processors when amd_pstate=active";
    platforms = platforms.linux;
    license = licenses.gpl3Only;
    maintainers = [ maintainers.lamarios ];
  };
}
