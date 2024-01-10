{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "mox";
  version = "0.0.8";

  src = fetchFromGitHub {
    owner = "mjl-";
    repo = "mox";
    rev = "v${version}";
    hash = "sha256-mr07nn0fy19j/Yv46Rxzt2qlqDHfnSkt3bjQvMQ7zsE=";
  };

  # set the version during buildtime
  patches = [ ./version.patch ];

  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
    "-X github.com/mjl-/mox/moxvar.Version=${version}"
  ];

  meta = {
    description = "Modern full-featured open source secure mail server for low-maintenance self-hosted email";
    homepage = "https://github.com/mjl-/mox";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dit7ya ];
  };
}
