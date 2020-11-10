{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "duf";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "muesli";
    repo = "duf";
    rev = "v${version}";
    sha256 = "093kir1zwpkl0jic4p1f032ir5k7kra94di2indzn0fa4j4r7a0i";
  };

  dontStrip = true;

  vendorSha256 = "1jqilfsirj7bkhzywimzf98w2b4s777phb06nsw6lr3bi6nnwzr1";

  buildFlagsArray = [ "-ldflags=" "-X=main.Version=${version}" ];

  meta = with lib; {
    homepage = "https://github.com/muesli/duf/";
    description = "Disk Usage/Free Utility";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ petabyteboy penguwin ];
  };
}
