{ lib, buildGoModule, fetchFromGitLab }:

buildGoModule rec {
  pname = "bluewalker";
  version = "0.3.0";

  src = fetchFromGitLab {
    owner = "jtaimisto";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-spuJRiNiaBV4EsetUq8vUfR6ejUNZxLhVzS3AZZyrrQ=";
  };

  vendorSha256 = "189qs6vmx63vwsjmc4qgf1y8xjsi7x6l1f5c3kd8j8jnagl26z4h";

  ldflags = [
    "-w"
    "-s"
  ];

  meta = with lib; {
    description = "Simple command line Bluetooth LE scanner";
    homepage = "https://gitlab.com/jtaimisto/bluewalker";
    changelog = "https://gitlab.com/jtaimisto/bluewalker/-/tags/v${version}";
    license = licenses.bsd2;
    maintainers = with maintainers; [ cimm ];
    platforms = platforms.linux;
  };
}
