{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "kubei";
  version = "1.0.12";

  src = fetchFromGitHub {
    owner = "Portshift";
    repo = pname;
    rev = version;
    sha256 = "sha256-QUPRw8fQ6ahBLZox6m4+feYIrcgDnCTe72nMF8iAV+Y=";
  };

  vendorSha256 = "sha256-uWDQf0zcTTPBthK60bmGJBP/m+yUu5PvYAbwyd0dcWE=";

  meta = with lib; {
    description = "Kubernetes runtime scanner";
    longDescription = ''
      Kubei is a vulnerabilities scanning and CIS Docker benchmark tool that
      allows users to get an accurate and immediate risk assessment of their
      kubernetes clusters. Kubei scans all images that are being used in a
      Kubernetes cluster, including images of application pods and system pods.
    '';
    homepage = "https://github.com/Portshift/kubei";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
