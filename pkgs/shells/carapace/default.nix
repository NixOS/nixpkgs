{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "carapace";
  version = "0.20.2";

  src = fetchFromGitHub {
    owner = "rsteube";
    repo = "${pname}-bin";
    rev = "v${version}";
    sha256 = "sha256-UPm0B3sv2+0/tS7NdqY5fpvMbI9B7CxixWF9M74H5w0=";
  };

  vendorHash = "sha256-l4DG6sZyFqu4OlxxL6mmcXTGljxY7xk5u5QlOr8dBNI=";

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
