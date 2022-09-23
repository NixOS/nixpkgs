{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gomacro";
  rev = "b4c3ab9b218fd12f22759354f4f3e37635828d1f";
  version = "20210131-${lib.strings.substring 0 7 rev}";

  src = fetchFromGitHub {
    owner = "cosmos72";
    repo = "gomacro";
    sha256 = "0ci486zqrhzvs3njn2ygaxsgjx3fn8bbj2q3sd80xvjiyjvq866g";
    inherit rev;
  };

  vendorSha256 = "1ib4h57drikyy5aq4ms6vc1p29djlpjrh7xd3bgyykr9zmm2w1kx";
  subPackages = [ "." ];

  meta = with lib; {
    description = "Interactive Go interpreter and debugger with generics and macros";
    homepage = "https://github.com/cosmos72/gomacro";
    license = licenses.mpl20;
    maintainers = with maintainers; [ shofius ];
  };
}
