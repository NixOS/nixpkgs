{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ligolo-ng";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "tnpitsecurity";
    repo = "ligolo-ng";
    rev = "v${version}";
    sha256 = "sha256-BuKSIJGeHuHfzcaADgGqKyQ6oy5RAUHyRs8e+d/Nf+0=";
  };

  postConfigure = ''
    export CGO_ENABLED=0
  '';

  ldflags = [ "-s" "-w" "-extldflags '-static'" ];

  vendorHash = "sha256-If0K6DmkGk3AmO3eb/ocAl1RJeBN/xgY7dOh9lnVLh8=";

  doCheck = false; # tests require network access

  meta = with lib; {
    homepage = "https://github.com/tnpitsecurity/ligolo-ng";
    description = "A tunneling/pivoting tool that uses a TUN interface";
    platforms = platforms.linux;
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ elohmeier ];
  };
}
