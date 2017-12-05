{ stdenv, fetchFromGitHub, cmake, perl, openssl, curl, libusb1 }:

stdenv.mkDerivation rec {
  name = "ttwatch-${version}";
  version = "2017-10-31";

  src = fetchFromGitHub {
    owner = "ryanbinns";
    repo = "ttwatch";
    rev = "f4103bdeb612a216ac21747941b3df943d67c48c";
    sha256 = "0fylycdi0g119d21l11yz23cjjhr3qdxjv02vz86zkc15kyvgsas";
  };

  nativeBuildInputs = [ cmake perl ];
  buildInputs = [ openssl curl libusb1 ];

  preFixup = ''
    chmod +x $out/bin/ttbin2mysports
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/ryanbinns/ttwatch;
    description = "Linux TomTom GPS Watch Utilities";
    maintainers = with maintainers; [ dotlambda ];
    license = licenses.mit;
    platforms = with platforms; linux;
  };
}
