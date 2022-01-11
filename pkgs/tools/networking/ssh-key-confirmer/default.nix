{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "ssh-key-confirmer";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "benjojo";
    repo = "ssh-key-confirmer";
    rev = "v${version}";
    sha256 = "18whj9ds3rpjj5b71lbadi37ps99v13nnmkn3vq28x6cqfdy6w09";
  };

  vendorSha256 = "0v9yw6v8fj6dqgbkks4pnmvxx9b7jqdy7bn7ywddk396sbsxjiqa";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Test ssh login key acceptance without having the private key";
    homepage = "https://github.com/benjojo/ssh-key-confirmer";
    license = licenses.mit;
    maintainers = with maintainers; [ oxzi ];
  };
}
