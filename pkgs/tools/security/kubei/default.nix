{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "kubei";
  version = "1.0.11";

  src = fetchFromGitHub {
    owner = "Portshift";
    repo = pname;
    rev = version;
    sha256 = "0n9kzlw7wlzkc3yhq68jgjhnvig817kz0q81ydkjxp4snwc1kvw8";
  };

  vendorSha256 = "0q0vkajn5n1aqb8wwdkvg8jv6j98l70g4hb399ickamhnirk69g4";

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
