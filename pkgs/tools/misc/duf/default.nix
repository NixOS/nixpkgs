{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "duf";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "muesli";
    repo = "duf";
    rev = "v${version}";
    sha256 = "1y27cc818099drccqg57nq4kcgl2zmg6akxv2k1c8rkz932q718f";
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
