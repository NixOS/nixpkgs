{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ligolo-ng";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "tnpitsecurity";
    repo = "ligolo-ng";
    rev = "v${version}";
    sha256 = "sha256-4VUzKTzeFC04c93PCnBnEoEoBDCyMg00uznv7ZOr+uY=";
  };

  postConfigure = ''
    export CGO_ENABLED=0
  '';

  ldflags = [ "-s" "-w" "-extldflags '-static'" ];

  vendorSha256 = "sha256-BoAEmgN+ufzT1vp7mzPzYcfdXKJVWaZq/fzA90e+z8M=";

  doCheck = false; # tests require network access

  meta = with lib; {
    homepage = "https://github.com/tnpitsecurity/ligolo-ng";
    description = "A tunneling/pivoting tool that uses a TUN interface";
    platforms = platforms.linux;
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ elohmeier ];
  };
}
