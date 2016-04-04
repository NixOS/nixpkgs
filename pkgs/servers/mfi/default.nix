{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  name = "mfi-controller-${version}";
  version = "2.1.11";

  src = fetchurl {
    url = "https://dl.ubnt.com/mfi/${version}/mFi.unix.zip";
    sha256 = "0b9q6025zf9zjzq8dcmcyai8rslx67g52j41gacxsk9i5dspmw90";
  };

  buildInputs = [ unzip ];

  dontBuild = true;

  installPhase = ''
    mkdir -p $out
    cp -ar conf data dl lib webapps $out
  '';

  meta = with stdenv.lib; {
    homepage = http://www.ubnt.com/;
    description = "Controller for Ubiquiti mFi devices";
    license = licenses.unfree;
    platforms = platforms.unix;
    maintainers = with maintainers; [ elitak ];
  };
}
