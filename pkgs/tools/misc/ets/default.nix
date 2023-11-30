{ lib, buildGoModule, fetchFromGitHub, fetchpatch, installShellFiles }:

buildGoModule rec {
  pname = "ets";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "zmwangx";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-XWIDo5msTMTLr60x1R9cwsiZIDG6G+uHWx8idt4F2iA=";
  };

  # https://github.com/zmwangx/ets/pull/18/
  patches = [ (fetchpatch {
    url = "https://github.com/zmwangx/ets/commit/600ec17a9c86ca63cd022d00439cdc4978e2afa9.patch";
    sha256 = "sha256-SGCISHkWNFubgKkQYx8Vf5/fknNDfPNYkSuw1mMhZaE=";
  }) ];

  vendorHash = "sha256-+8dXfqOu8XTw2uEx3GAynQSHtzifejZtddr1CdxrupA=";

  ldflags = [ "-s" "-w" "-X main.version=v${version}-nixpkgs" ];

  nativeBuildInputs = [ installShellFiles ];

  preBuild = ''
    rm -rf fixtures
  '';

  postInstall = ''
    installManPage ets.1
  '';

  doCheck = false;

  meta = with lib; {
    description = "Command output timestamper";
    homepage = "https://github.com/zmwangx/ets/";
    license = licenses.mit;
    maintainers = with maintainers; [ cameronfyfe ];
    mainProgram = "ets";
  };
}
