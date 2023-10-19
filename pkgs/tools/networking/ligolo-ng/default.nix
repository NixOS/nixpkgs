{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ligolo-ng";
  version = "0.4.4";

  src = fetchFromGitHub {
    owner = "tnpitsecurity";
    repo = "ligolo-ng";
    rev = "v${version}";
    hash = "sha256-bv611kvjyXvWVkWpymQn4NLtDAYuXnNi1c3yT3t3p+8=";
  };

  vendorHash = "sha256-MEG1p8PJinFOPIU9+9cxtU9FweCgVMYX8KojQ3ZhKKs=";

  postConfigure = ''
    export CGO_ENABLED=0
  '';

  ldflags = [ "-s" "-w" "-extldflags '-static'" ];

  doCheck = false; # tests require network access

  meta = with lib; {
    homepage = "https://github.com/tnpitsecurity/ligolo-ng";
    description = "A tunneling/pivoting tool that uses a TUN interface";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ elohmeier ];
  };
}
