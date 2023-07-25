{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "tran";
  version = "0.1.43";

  src = fetchFromGitHub {
    owner = "abdfnx";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-qp4g1ZLRIIz0CZ/Zey354g0j9ePE4pGb82IivLezU7s=";
  };

  vendorSha256 = "sha256-JmRTI5ZBSFULfI+ki3hI8TPaS6IVP9D14r4DwK/nx1Y=";

  ldflags = [
    "-w"
    "-s"
    "-X main.version=v${version}"
  ];

  subPackages = [ "." ];

  meta = with lib; {
    description = "Securely transfer and send anything between computers with TUI";
    homepage = "https://github.com/abdfnx/tran";
    license = licenses.mit;
    maintainers = with maintainers; [ dit7ya ];
  };
}
