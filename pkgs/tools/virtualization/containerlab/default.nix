{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "containerlab";
  version = "0.32.1";

  src = fetchFromGitHub {
    owner = "srl-labs";
    repo = "containerlab";
    rev = "007da91652ca309d90ca557ebaaf49baab7bc413";
    sha256 = "sha256-4phBYr2gRROpvp13G3zI8Ma7nSD9usF/UcttUJJoGI4=";
  };

  vendorSha256 = "sha256-DfjhFznWlfT/IZwq+XLP6b6Zb0fv4hZgvdgCKggFUnc=";
  subPackages = [ "." ];

  preBuild = ''
    sed -i -E 's|(version\s+\=\ )\"\0.0.0\"|\1"${version}"|g' cmd/version.go
    sed -i -E 's|(commit\s+\=\ )\"none\"|\1"v${version}"|g' cmd/version.go
  '';

  meta = with lib; {
    description = "containerlab enables container-based networking labs";
    homepage = "https://github.com/srl-labs/containerlab";
    license = licenses.unfree;
    maintainers = with maintainers; [ rwxd ];
    platforms = platforms.linux;
  };
}
