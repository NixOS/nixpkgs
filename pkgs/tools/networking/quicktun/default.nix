{ stdenv, fetchFromGitHub, libsodium }:

stdenv.mkDerivation rec {
  name = "quicktun-${version}";
  version = "2.2.5";

  src = fetchFromGitHub {
    owner = "UCIS";
    repo = "QuickTun";
    rev = "2d0c6a9cda8c21f921a5d1197aeee92e9568ca39";
    sha256 = "1ydvwasj84qljfbzh6lmhyzjc20yw24a0v2mykp8afsm97zzlqgx";
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
    homepage = http://wiki.ucis.nl/QuickTun;
    maintainers = [ maintainers.fpletz ];
    platforms = platforms.unix;
  };
}
