{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "pocketbase";
  version = "0.16.3";

  src = fetchFromGitHub {
    owner = "pocketbase";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-AKKCd80gxeL2s1yFX3pjwgxn7UDbrrhFUkMWDDcrN0c=";
  };

  vendorHash = "sha256-J1vZn5x7wxM/UshcB+FdaiXiq4mZF7KvZxR5iPb37UQ=";

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
    maintainers = with maintainers; [ dit7ya ];
  };
}
