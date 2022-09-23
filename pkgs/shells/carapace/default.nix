{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "carapace";
  version = "0.15.1";

  src = fetchFromGitHub {
    owner = "rsteube";
    repo = "${pname}-bin";
    rev = "v${version}";
    sha256 = "sha256-zfW2YbMybE2ZOYVNdmxAE0HwDTDeaVa0SrSUahyuTTk=";
  };

  vendorSha256 = "sha256-MIgV8of3d9STMYtK+9gGkKBZ5Y4l5NhofK5F1Yfi/kE=";

  subPackages = [ "./cmd/carapace" ];

  tags = [ "release" ];

  preBuild = ''
    go generate ./...
  '';

  meta = with lib; {
    description = "Multi-shell multi-command argument completer";
    homepage = "https://rsteube.github.io/carapace-bin/";
    maintainers = with maintainers; [ mredaelli ];
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
