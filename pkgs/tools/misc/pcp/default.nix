{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "pcp";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "dennis-tra";
    repo = "pcp";
    rev = "v${version}";
    sha256 = "sha256-aZO8VuOiYhOPctFKZ6a2psJB0lKHlPc+NLy2RWDU4JI=";
  };

  vendorHash = "sha256-3bkzBQ950Phg4A9p+IjeUx7Xw7eVmUbeYnQViNjghFk=";

  meta = with lib; {
    description = "Command line peer-to-peer data transfer tool based on libp2p";
    homepage = "https://github.com/dennis-tra/pcp";
    license = licenses.asl20;
    maintainers = with maintainers; [ matthewcroughan ];
    platforms = platforms.linux;
  };
}
