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

  ldflags = [ # omit some things for a smaller binary
    "-w" # omit the DWARF symbol table
    "-s" # omit symbol table and debug info
  ];

  meta = with lib; {
    description = "Simple command line Bluetooth LE scanner";
    homepage = src.meta.homepage;
    changelog = "https://gitlab.com/jtaimisto/${pname}/-/raw/master/CHANGELOG";
    license = licenses.bsd2;
    maintainers = with maintainers; [ cimm ];
    platforms = platforms.linux;
  };
}
