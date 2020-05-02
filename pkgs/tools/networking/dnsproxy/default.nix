{ stdenv, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "dnsproxy";
  version = "0.28.1";

  src = fetchFromGitHub {
    owner = "AdguardTeam";
    repo = pname;
    rev = "v${version}";
    sha256 = "1pa4skrhdcblqs8r1kik5g8h9p6pcin5pd7b1dh7xk2n86xs8j22";
  };

  vendorSha256 = null;

  meta = with stdenv.lib; {
    description = "Simple DNS proxy with DoH, DoT, and DNSCrypt support";
    homepage = "https://github.com/AdguardTeam/dnsproxy";
    license = licenses.gpl3;
    maintainers = with maintainers; [ contrun ];
    platforms = platforms.all;
  };
}