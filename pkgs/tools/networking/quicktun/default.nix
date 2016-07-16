{ stdenv, fetchFromGitHub, libsodium }:

stdenv.mkDerivation rec {
  name = "quicktun-${version}";
  version = "2.2.4-git-2016-07-04";

  src = fetchFromGitHub {
    owner = "UCIS";
    repo = "QuickTun";
    rev = "b9c6da398e012830454d38baac96bb30f927a749";
    sha256 = "1imbnks3ba72cxx58a9260zxy0xcsa2srf77cq02kqsakarfylal";
  };

  buildInputs = [ libsodium ];

  phases = [ "unpackPhase" "buildPhase" "installPhase" ];

  buildPhase = "bash build.sh";

  installPhase = ''
    mkdir -p $out/bin
    rm out/quicktun*tgz
    cp -v out/quicktun* $out/bin/
  '';

  meta = with stdenv.lib; {
    description = "Very simple, yet secure VPN software";
    homepage = "http://wiki.ucis.nl/QuickTun";
    maintainers = [ maintainers.fpletz ];
    platforms = platforms.unix;
  };
}
