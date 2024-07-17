{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "fission";
  version = "1.20.1";

  src = fetchFromGitHub {
    owner = "fission";
    repo = "fission";
    rev = "v${version}";
    hash = "sha256-RT4hBr7qxhhJM1REJFIE9En1Vu3ACvXav242PBYz8IQ=";
  };

  vendorHash = "sha256-hZmQxG4cw1Len3ZyGhWVTXB8N9fDRkgNDyF18/8dKuo=";

  ldflags = [
    "-s"
    "-w"
    "-X info.Version=${version}"
  ];

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
