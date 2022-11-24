{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "carapace";
  version = "0.18.0";

  src = fetchFromGitHub {
    owner = "rsteube";
    repo = "${pname}-bin";
    rev = "v${version}";
    sha256 = "sha256-dZ1TeBIP8560VHdDBR6JRbJaZmpvmKKUqzZ7ZYGsEXk=";
  };

  vendorSha256 = "sha256-6+hooVadDN/unf5oMyVzC3pjXwVLzsYBt7vzKuYUgXU=";

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
