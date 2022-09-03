{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ligolo-ng";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "tnpitsecurity";
    repo = "ligolo-ng";
    rev = "v${version}";
    sha256 = "sha256-KXyvoHtPC71QkB+X6cRCBxAUcTuy+j8/ZAJe7n6EdGc=";
  };

  postConfigure = ''
    export CGO_ENABLED=0
  '';

  ldflags = [ "-s" "-w" "-extldflags '-static'" ];

  vendorSha256 = "sha256-dzHdPgOjYXSozDxehkVNQocsYdH0u0p80c1THUzedk8=";

  doCheck = false; # tests require network access

  meta = with lib; {
    homepage = "https://github.com/tnpitsecurity/ligolo-ng";
    description = "A tunneling/pivoting tool that uses a TUN interface";
    platforms = platforms.linux;
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ elohmeier ];
  };
}
