{ lib, stdenv, fetchFromGitHub, libsodium }:

stdenv.mkDerivation {
  pname = "quicktun";
  version = "2.2.5";

  src = fetchFromGitHub {
    owner = "UCIS";
    repo = "QuickTun";
    rev = "2d0c6a9cda8c21f921a5d1197aeee92e9568ca39";
    sha256 = "1ydvwasj84qljfbzh6lmhyzjc20yw24a0v2mykp8afsm97zzlqgx";
  };

  patches = [ ./tar-1.30.diff ]; # quicktun master seems not to need this

  buildInputs = [ libsodium ];

  buildPhase = "bash build.sh";

  installPhase = ''
    rm out/quicktun*tgz
    install -vD out/quicktun* -t $out/bin
  '';

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Very simple, yet secure VPN software";
    homepage = "http://wiki.ucis.nl/QuickTun";
    maintainers = [ ];
    platforms = platforms.unix;
    license = licenses.bsd2;
  };
}
