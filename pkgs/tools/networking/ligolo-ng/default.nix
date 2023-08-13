{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ligolo-ng";
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "tnpitsecurity";
    repo = "ligolo-ng";
    rev = "v${version}";
    hash = "sha256-O/qiznQs+x7qBYXVItd0W7a0irEzRf0We7kW7HHLqcw=";
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
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ elohmeier ];
  };
}
