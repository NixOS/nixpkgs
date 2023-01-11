{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "carapace";
  version = "0.19.1";

  src = fetchFromGitHub {
    owner = "rsteube";
    repo = "${pname}-bin";
    rev = "v${version}";
    sha256 = "sha256-RAomMEq7m8PVbRMtQqcHUOXzxgLuwacGPP3U78jYXEg=";
  };

  vendorHash = "sha256-2vs/v5G+8pkrtO2PzXkya0vRlwFmhvEu5mDNij4adqY=";

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
