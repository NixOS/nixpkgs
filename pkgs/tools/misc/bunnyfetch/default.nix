{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "bunnyfetch";
  version = "unstable-2021-05-24";

  src = fetchFromGitHub {
    owner = "Mewyuna";
    repo = pname;
    rev = "7bcc45fb590b37f410e60af893e679eb0729ecb1";
    sha256 = "1lgqrwmxdxd1d99rr0akydfwcsbcmz75fkbq9zrl842rksnp5q3r";
  };

  vendorSha256 = "1vv69y0x06kn99lw995sbkb7vgd0yb18flkr2ml8ss7q2yvz37vi";

  # No upstream tests
  doCheck = false;

  subPackages = [ "." ];

  meta = with lib; {
    description = "Tiny system info fetch utility";
    homepage = "https://github.com/Mewyuna/bunnyfetch";
    license = licenses.mit;
    maintainers = with maintainers; [ devins2518 ];
    platforms = platforms.linux;
  };
}
