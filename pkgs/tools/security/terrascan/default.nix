{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "terrascan";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "accurics";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-YUrvdleH332fWDgq8AwUdXkFC7m9ap+OVuQhKlxZfII=";
  };

  vendorSha256 = "sha256-CzJ83MsBetrzbBT+fmz8F8MjdrManJAd4xpykh/2938=";

  # tests want to download a vulnerable Terraform project
  doCheck = false;

  meta = with lib; {
    description = "Detect compliance and security violations across Infrastructure";
    longDescription = ''
      Detect compliance and security violations across Infrastructure as Code to
      mitigate risk before provisioning cloud native infrastructure. It contains
      500+ polices and support for Terraform and Kubernetes.
    '';
    homepage = "https://github.com/accurics/terrascan";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
