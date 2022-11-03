{ lib, buildGoModule, fetchFromGitHub, git, updateGolangSysHook }:

buildGoModule rec {
  pname = "go-license-detector";
  version = "4.3.0";

  src = fetchFromGitHub {
    owner = "go-enry";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-MubQpxpUCPDBVsEz4NmY8MFEoECXQtzAaZJ89vv5bDc=";
  };

  nativeBuildInputs = [ updateGolangSysHook ];

  vendorSha256 = "sha256-dj1c8LbIgtWf+Mkagklm5UFnT4NX3JVzOYOmm4K9xTM=";

  checkInputs = [ git ];

  meta = with lib; {
    description = "Reliable project licenses detector";
    homepage = "https://github.com/go-enry/go-license-detector";
    license = licenses.asl20;
    maintainers = with maintainers; [ dtzWill ];
    mainProgram = "license-detector";
  };
}
