{ lib
, fetchFromGitHub
, buildGoModule
}:
buildGoModule rec {
  pname = "hysteria";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "HyNetwork";
    repo = "hysteria";
    rev = "v${version}";
    sha256 = "sha256-V+umf7+qRANSNsMrU1Vij3ni6ayq/d41xSy3o+7sEHQ=";
  };

  vendorSha256 = "sha256-oxCZ4+E3kffHr8ca9BKCSYcSWQ8jwpzrFs0fvCvZyJE=";
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
