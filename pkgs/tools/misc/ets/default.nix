{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ets";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "zmwangx";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-XWIDo5msTMTLr60x1R9cwsiZIDG6G+uHWx8idt4F2iA=";
  };

  patches = [ ./go-mod.patch ];

  vendorSha256 = "sha256-+8dXfqOu8XTw2uEx3GAynQSHtzifejZtddr1CdxrupA=";

  ldflags = [ "-s" "-w" "-X main.version=v${version}-nixpkgs" ];

  preBuild = ''
    rm -rf fixtures
  '';

  postInstall = ''
    mkdir -p $out/share/man/man1
    cp ets.1 $out/share/man/man1
  '';

  doCheck = false;

  meta = with lib; {
    description = "Command output timestamper";
    homepage = "https://github.com/zmwangx/ets/";
    license = licenses.mit;
    maintainers = with maintainers; [ cameronfyfe ];
  };
}
