{ stdenv, fetchFromGitHub, libjpeg }:

stdenv.mkDerivation rec {
  pname = "jhead";
  version = "3.06.0.1";

  src = fetchFromGitHub {
    owner = "Matthias-Wandel";
    repo = "jhead";
    rev = version;
    sha256 = "0zgh36486cpcnf7xg6dwf7rhz2h4gpayqvdk8hmrx6y418b2pfyf";
  };

  buildInputs = [ libjpeg ];

  makeFlags = [ "CPPFLAGS=" "CFLAGS=-O3" "LDFLAGS=" ];

  installPhase = ''
    mkdir -p \
      $out/bin \
      $out/man/man1 \
      $out/share/doc/${pname}-${version}

    cp -v jhead $out/bin
    cp -v jhead.1 $out/man/man1
    cp -v *.txt $out/share/doc/${pname}-${version}
  '';

  meta = with stdenv.lib; {
    homepage = "http://www.sentex.net/~mwandel/jhead/";
    description = "Exif Jpeg header manipulation tool";
    license = licenses.publicDomain;
    maintainers = with maintainers; [ rycee ];
    platforms = platforms.all;
  };
}
