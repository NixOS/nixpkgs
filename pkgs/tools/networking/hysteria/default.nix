{ lib
, fetchFromGitHub
, buildGoModule
}:
buildGoModule rec {
  pname = "hysteria";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "HyNetwork";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-aHIb79P1a+91hIcK1toHZqqXIZ0rwfGXDQc42rQQmX4=";
  };

  vendorSha256 = "sha256-yAQpyz4pDXOfGF4hho/2Pt9yD3VdWYAmIvaXJjDMjis=";
  proxyVendor = true;

  # Network required
  doCheck = false;

  meta = with lib; {
    description = "A feature-packed proxy & relay utility optimized for lossy, unstable connections";
    homepage = "https://github.com/HyNetwork/hysteria";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ oluceps ];
  };
}
