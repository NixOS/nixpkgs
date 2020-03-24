{ stdenv, fetchFromGitHub, python3 }:

stdenv.mkDerivation rec {
  pname = "tuptime";
  version = "4.1.0";

  src = fetchFromGitHub {
    owner = "rfrail3";
    repo = "tuptime";
    rev = version;
    sha256 = "0p5v1jp6bl0hjv04q3gh11q6dx9z0x61h6svcbvwp5ni0h1bkz1a";
  };

  buildInputs = [ python3 ];

  installPhase = ''
    mkdir -p $out/bin
    install -m 755 src/tuptime $out/bin/

    mkdir -p $out/share/man/man1
    cp src/man/tuptime.1 $out/share/man/man1/

    # upstream only ships this, there are more scripts there...
    mkdir -p $out/usr/share/doc/tuptime/contrib
    cp misc/scripts/uptimed-to-tuptime.py $out/usr/share/doc/tuptime/contrib/
  '';

  meta = with stdenv.lib; {
    description = "Total uptime & downtime statistics utility";
    homepage = "https://github.com/rfrail3/tuptime";
    license = licenses.gpl2;
    platforms = platforms.all;
    maintainers = [ maintainers.evils ];
  };
}
