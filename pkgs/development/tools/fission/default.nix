{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "fission";
  version = "1.14.1";

  src = fetchFromGitHub {
    owner = "fission";
    repo = "fission";
    rev = version;
    sha256 = "sha256-U/UV5NZXmycDp8+g5XV6P2b+4SutR51rVHdPp9HdPjM=";
  };

  vendorSha256 = "sha256-1ujJuhK7pm/A1Dd+Wm9dtc65mx9pwLBWMWwEJnbja8s=";

  ldflags = [ "-s" "-w" "-X info.Version=${version}" ];

  subPackages = [ "cmd/fission-cli" ];

  postInstall = ''
    ln -s $out/bin/fission-cli $out/bin/fission
  '';

  meta = with lib; {
    description = "The cli used by end user to interact Fission";
    homepage = "https://fission.io";
    license = licenses.asl20;
    maintainers = with maintainers; [ neverbehave ];
  };
}
