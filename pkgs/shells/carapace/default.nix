{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "carapace";
  version = "0.8.10";

  src = fetchFromGitHub {
    owner = "rsteube";
    repo = "${pname}-bin";
    rev = "v${version}";
    sha256 = "0j60fvrmjm4440gj9hib2ar386zxcblw7yifigsnchr7p3i2187n";
  };

  vendorSha256 = "1s1sws79cyz1rl63wayzf7yhb04x29a4a1mkifqnl4cc2pv806jf";

  subPackages = [ "./cmd/carapace" ];

  tags = [ "release" ];

  preBuild = ''
    go generate ./...
  '';

  meta = with lib; {
    description = "Multi-shell multi-command argument completer";
    homepage = "https://rsteube.github.io/carapace-bin/";
    maintainers = with maintainers; [ mredaelli ];
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
