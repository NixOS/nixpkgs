{ lib
, buildGoModule
, fetchFromGitHub
, updateGolangSysHook
}:

buildGoModule rec {
  pname = "vt-cli";
  version = "0.10.2";

  src = fetchFromGitHub {
    owner = "VirusTotal";
    repo = pname;
    rev = version;
    sha256 = "0jqr2xf6f9ywavkx5hzcfnky8ax23ahdj24hjsnq6zlpdqvfn1xb";
  };

  nativeBuildInputs = [ updateGolangSysHook ];

  vendorSha256 = "sha256-wM5VPcNGEgnUvJEFrbcLVFAlzCA6a+a97xLeK5x0IEI=";

  ldflags = [
    "-X github.com/VirusTotal/vt-cli/cmd.Version=${version}"
  ];

  subPackages = [ "vt" ];

  meta = with lib; {
    description = "VirusTotal Command Line Interface";
    homepage = "https://github.com/VirusTotal/vt-cli";
    license = licenses.asl20;
    maintainers = with maintainers; [ dit7ya ];
  };
}
