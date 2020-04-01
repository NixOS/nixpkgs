{ stdenv, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "dnsproxy";
  version = "0.24.0";

  src = fetchFromGitHub {
    owner = "AdguardTeam";
    repo = pname;
    rev = "v${version}";
    sha256 = "1jwy2qi99ks6zcas6h1n0zq3b0k47036ayas0mprdips60azw0hg";
  };

  modSha256 = "0kba3jay6m9ir1pc7i833p7ylbs610g0lkp8kc3gm47xnxy7j4gz";

  meta = with stdenv.lib; {
    description = "Simple DNS proxy with DoH, DoT, and DNSCrypt support";
    homepage = "https://github.com/AdguardTeam/dnsproxy";
    license = licenses.gpl3;
    maintainers = with maintainers; [ contrun ];
    platforms = platforms.all;
  };
}
