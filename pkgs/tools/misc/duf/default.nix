{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "duf";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "muesli";
    repo = "duf";
    rev = "v${version}";
    sha256 = "0n0nvrqrlr75dmf2j6ja615ighzs35cfixn7z9cwdz3vhj1xhc5f";
  };

  dontStrip = true;

  vendorSha256 = "1jqilfsirj7bkhzywimzf98w2b4s777phb06nsw6lr3bi6nnwzr1";

  buildFlagsArray = [ "-ldflags=" "-X=main.Version=${version}" ];

  meta = with lib; {
    homepage = "https://github.com/muesli/duf/";
    description = "Disk Usage/Free Utility";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ petabyteboy penguwin ];
  };
}
