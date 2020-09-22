{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "duf";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "muesli";
    repo = "duf";
    rev = "v${version}";
    sha256 = "1akziaa5wjszflyylvnw284pz1aqngl40civzfabjz94pvyjkp76";
  };

  vendorSha256 = "1aj7rxlylgvxdnnfnfzh20v2jvs8falvjjishxd8rdk1jgfpipl8";

  meta = with lib; {
    homepage = "https://github.com/muesli/duf/";
    description = "Disk Usage/Free Utility";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ petabyteboy ];
  };
}
