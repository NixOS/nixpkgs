{ stdenv, fetchFromGitHub, libsodium }:

stdenv.mkDerivation rec {
  name = "quicktun-${version}";
  version = "2.2.4";

  src = fetchFromGitHub {
    owner = "UCIS";
    repo = "QuickTun";
    rev = "980fe1b8c718d6df82af1d57b56140c0e541dbe0";
    sha256 = "0m7gvlgs1mhyw3c8s2dg05j7r7hz8kjpb0sk245m61ir9dmwlf8i";
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
