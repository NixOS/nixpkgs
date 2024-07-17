{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "mesos-dns";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "m3scluster";
    repo = "mesos-dns";
    rev = "v${version}";
    hash = "sha256-lURD0WAHC4klRdV6/YhKNtXh03zcVuDzTj/LvKYomLk=";
  };

  vendorHash = "sha256-OILARWv9CDQEzzn7He/P8Z2Ug7m05AqOndoeM1sUpII=";

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    homepage = "https://m3scluster.github.io/mesos-dns/";
    changelog = "https://github.com/m3scluster/mesos-dns/releases/tag/v${version}";
    description = "DNS-based service discovery for Mesos";
    license = licenses.asl20;
    maintainers = with maintainers; [ aaronjheng ];
    mainProgram = "mesos-dns";
  };
}
