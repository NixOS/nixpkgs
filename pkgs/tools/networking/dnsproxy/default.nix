{ stdenv, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "dnsproxy";
  version = "0.27.1";

  src = fetchFromGitHub {
    owner = "AdguardTeam";
    repo = pname;
    rev = "v${version}";
    sha256 = "0nsj75aw5dym1pzn18p6fzh17vcryz1xs4xly6ga79dkpyijr9j8";
  };

  modSha256 = "1m8565hkn981b6xld8jyrbxay48ww8lzr94kgakx0rg5548kd7v5";

  meta = with stdenv.lib; {
    description = "Simple DNS proxy with DoH, DoT, and DNSCrypt support";
    homepage = "https://github.com/AdguardTeam/dnsproxy";
    license = licenses.gpl3;
    maintainers = with maintainers; [ contrun ];
    platforms = platforms.all;
  };
}
