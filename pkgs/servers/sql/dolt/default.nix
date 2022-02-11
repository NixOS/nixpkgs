{ fetchFromGitHub, lib, buildGoModule }:

buildGoModule rec {
  pname = "dolt";
  version = "0.36.1";

  src = fetchFromGitHub {
    owner = "liquidata-inc";
    repo = "dolt";
    rev = "v${version}";
    sha256 = "sha256-vROGIkXyVR+xoLQ8IIYvcFqVpm0v043v7aKEJ5pygD8=";
  };

  modRoot = "./go";
  subPackages = [ "cmd/dolt" "cmd/git-dolt" "cmd/git-dolt-smudge" ];
  vendorSha256 = "sha256-p+Ryg+uPwhCAHSwCBtxrVCSN7Xj3roHjoJHK8W3S+gE=";

  doCheck = false;

  meta = with lib; {
    description = "Relational database with version control and CLI a-la Git";
    homepage = "https://github.com/liquidata-inc/dolt";
    license = licenses.asl20;
    maintainers = with maintainers; [ danbst ];
  };
}
