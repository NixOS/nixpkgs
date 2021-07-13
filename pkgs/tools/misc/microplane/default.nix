{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "microplane";
  version = "0.0.32";

  src = fetchFromGitHub {
    owner = "Clever";
    repo = "microplane";
    rev = "v${version}";
    sha256 = "sha256-QYii/UmYus5hloTUsbVKsw50bSfI4bArUgGzFSK8Cas=";
  };

  vendorSha256 = "sha256-1XtpoGqQ//2ccJdl8E7jnSBQhYoA4/YVBbHeI+OfaR0=";

  buildFlagsArray = ''
    -ldflags=-s -w -X main.version=${version}
  '';

  postInstall = ''
    ln -s $out/bin/microplane $out/bin/mp
  '';

  meta = with lib; {
    description = "A CLI tool to make git changes across many repos";
    homepage = "https://github.com/Clever/microplane";
    license = licenses.asl20;
    maintainers = with maintainers; [ dbirks ];
  };
}
