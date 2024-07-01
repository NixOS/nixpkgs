{ lib
, fetchFromGitHub
, buildGoModule
}:
buildGoModule rec {
  pname = "hysteria";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "apernet";
    repo = pname;
    rev = "app/v${version}";
    hash = "sha256-vtGJRPQBOO8Ig794FJ3gTrR0LOZdWH1vAc7IcZSq/SE=";
  };

  vendorHash = "sha256-1VLws98/iAW8BnxOhbshp01D6+kb4CJOvncC5floN5o=";
  proxyVendor = true;

  ldflags =
    let cmd = "github.com/apernet/hysteria/app/cmd";
    in [
      "-s"
      "-w"
      "-X ${cmd}.appVersion=${version}"
      "-X ${cmd}.appType=release"
    ];

  postInstall = ''
    mv $out/bin/app $out/bin/hysteria
  '';

  # Network required
  doCheck = false;

  meta = with lib; {
    description = "Feature-packed proxy & relay utility optimized for lossy, unstable connections";
    homepage = "https://github.com/apernet/hysteria";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ oluceps ];
    mainProgram = "hysteria";
  };
}
