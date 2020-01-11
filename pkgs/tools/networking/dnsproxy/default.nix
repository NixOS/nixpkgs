{ stdenv, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "dnsproxy";
  version = "0.20.0";

  src = fetchFromGitHub {
    owner = "AdguardTeam";
    repo = pname;
    rev = "v${version}";
    sha256 = "0yd3d90ssdzpbsdq068dvsi0r1z2rlv3wpbmpkhfgpxmwrvdanrq";
  };

  modSha256 = "0cqwkmhajp3py3b5aj3qz9480qy2ws0vy1gk21bxjm56wqxl2gf0";

  meta = with stdenv.lib; {
    description = "Simple DNS proxy with DoH, DoT, and DNSCrypt support";
    homepage = "https://github.com/AdguardTeam/dnsproxy";
    license = licenses.gpl3;
    maintainers = with maintainers; [ contrun ];
    platforms = platforms.all;
  };
}
