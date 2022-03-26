{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "nmap-formatter";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "vdjagilev";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-tG91Cutk+RCBPv4Rf8CVnZa5Wh8qgsxEL0C6WIoEdsw=";
  };

  vendorSha256 = "sha256-WXX1b8fPcwIE40w+Kzd7ZuSRXPiYtolRXC/Z8Kc9H2s=";

  postPatch = ''
    # Fix hard-coded release
    substituteInPlace cmd/root.go \
      --replace "0.2.0" "${version}"
  '';

  meta = with lib; {
    description = "Tool that allows you to convert nmap output";
    homepage = "https://github.com/vdjagilev/nmap-formatter";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
