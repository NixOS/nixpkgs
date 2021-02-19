{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "zrepl";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "zrepl";
    repo = "zrepl";
    rev = "v${version}";
    sha256 = "sha256-wtUL8GGSJxn9yEdyTWKtkHODfxxLOxojNPlPLRjI9xo=";
  };

  vendorSha256 = "sha256-4LBX0bD8qirFaFkV52QFU50lEW4eae6iObIa5fFT/wA=";

  subPackages = [ "." ];

  postInstall = ''
    mkdir -p $out/lib/systemd/system
    substitute dist/systemd/zrepl.service $out/lib/systemd/system/zrepl.service \
      --replace /usr/local/bin/zrepl $out/bin/zrepl
  '';

  meta = with lib; {
    homepage = "https://zrepl.github.io/";
    description = "A one-stop, integrated solution for ZFS replication";
    platforms = platforms.linux;
    license = licenses.mit;
    maintainers = with maintainers; [ cole-h danderson ];
  };
}
