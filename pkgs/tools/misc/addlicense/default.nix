{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "addlicense";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "addlicense";
    rev = "v${version}";
    sha256 = "sha256-Nv7Az3TDtd1P/QWjH92otSV9rIrc2l/mTbGUXhODi7Q=";
  };

  vendorSha256 = "sha256-2mncc21ecpv17Xp8PA9GIodoaCxNBacbbya/shU8T9Y=";

  subPackages = [ "." ];

  meta = with lib; {
    description = "Ensures source code files have copyright license headers by scanning directory patterns recursively";
    homepage = "https://github.com/google/addlicense";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
