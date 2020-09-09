{ stdenv, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "dnsproxy";
  version = "0.32.0";

  src = fetchFromGitHub {
    owner = "AdguardTeam";
    repo = pname;
    rev = "v${version}";
    sha256 = "14iwwg1iqfxjhpw9p3ddq53l901v9l9n2r60q9q6jls8hfqcgsnj";
  };

  vendorSha256 = null;

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Simple DNS proxy with DoH, DoT, and DNSCrypt support";
    homepage = "https://github.com/AdguardTeam/dnsproxy";
    license = licenses.gpl3;
    maintainers = with maintainers; [ contrun ];
  };
}
