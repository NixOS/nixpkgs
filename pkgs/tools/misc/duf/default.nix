{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "duf";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "muesli";
    repo = "duf";
    rev = "v${version}";
    sha256 = "08vmhcvqn9g86iqwk42bj0i09lmchhdgha1xaj1jw1ci4k7s9vrf";
  };

  vendorSha256 = "1jmj46yami37r2wmiprpwyljcmj7dir9mcccx5is1jbiai6sx79i";

  meta = with lib; {
    homepage = "https://github.com/muesli/duf/";
    description = "Disk Usage/Free Utility";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ petabyteboy ];
  };
}
