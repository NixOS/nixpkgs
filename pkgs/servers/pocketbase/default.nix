{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "pocketbase";
  version = "0.18.10";

  src = fetchFromGitHub {
    owner = "pocketbase";
    repo = "pocketbase";
    rev = "v${version}";
    hash = "sha256-fbzoUmxWwQYEGrUIXtHP6Lz71C51TR30gz+5deB00LM=";
  };

  vendorHash = "sha256-b0i+I/HzHbpmgclYn2g6MtpbslT/sLm9K2woMjvWaD0=";

  # This is the released subpackage from upstream repo
  subPackages = [ "examples/base" ];

  CGO_ENABLED = 0;

  # Upstream build instructions
  ldflags = [
    "-s"
    "-w"
    "-X github.com/pocketbase/pocketbase.Version=${version}"
  ];

  postInstall = ''
    mv $out/bin/base $out/bin/pocketbase
  '';

  meta = with lib; {
    description = "Open Source realtime backend in 1 file";
    homepage = "https://github.com/pocketbase/pocketbase";
    license = licenses.mit;
    maintainers = with maintainers; [ dit7ya thilobillerbeck ];
  };
}
