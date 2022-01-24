{ lib, fetchFromGitHub, buildGoModule, fetchpatch }:

buildGoModule rec {
  version = "0.6.0";
  pname = "grobi";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "fd0";
    repo = "grobi";
    sha256 = "032lvnl2qq9258y6q1p60lfi7qir68zgq8zyh4khszd3wdih7y3s";
  };

  vendorSha256 = "1ibwx5rbxkygfx78j3g364dmbwwa5b34qmzq3sqcbrsnv8rzrwvj";

  patches = [
    # fix failing test on go 1.15
    (fetchpatch {
      url = "https://github.com/fd0/grobi/commit/176988ab087ff92d1408fbc454c77263457f3d7e.patch";
      sha256 = "0j8y3gns4lm0qxqxzmdn2ll0kq34mmfhf83lvsq13iqhp5bx3y31";
    })
  ];

  meta = with lib; {
    homepage = "https://github.com/fd0/grobi";
    description = "Automatically configure monitors/outputs for Xorg via RANDR";
    license = with licenses; [ bsd2 ];
    platforms   = platforms.linux;
  };
}
