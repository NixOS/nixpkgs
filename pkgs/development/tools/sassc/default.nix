{ stdenv, fetchFromGitHub, autoconf, automake, libtool, libsass }:

stdenv.mkDerivation rec {
  name = "sassc";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "sass";
    repo = "sassc";
    rev = version;
    sha256 = "0lpilmsir9b9292a4b8kq3zzg5cfh031p0krgam5rmsn39i6ivs4";
  };

  preConfigure = ''
    export SASSC_VERSION="3.1.0"
    autoreconf --force --install
  '';

  buildInputs = [ autoconf automake libtool libsass ];

  installPhase = ''
    mkdir -p $out/bin
    cp sassc $out/bin/
  '';

  meta = with stdenv.lib; {
    description = "A front-end for libsass";
    license = licenses.mit;
    homepage = https://github.com/sass/sassc/;
    maintainers = with maintainers; [ pjones ];
    platforms = platforms.unix;
  };
}
