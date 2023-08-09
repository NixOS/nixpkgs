{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "fission";
  version = "1.19.0";

  src = fetchFromGitHub {
    owner = "fission";
    repo = "fission";
    rev = "v${version}";
    hash = "sha256-Ui7HGiWjzbhEOLuxC3TkFqDwwi3YsLMuxhZsPrJzPN0=";
  };

  vendorHash = "sha256-XQd5jTZ37DhvQq7x1OyhIb1uoMv5Y7Ayv4CX33BCLBE=";

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
