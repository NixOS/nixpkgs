{ stdenv, fetchFromGitHub, cmake, perl, openssl, curl, libusb1 }:

stdenv.mkDerivation rec {
  name = "ttwatch-${version}";
  version = "2017-04-20";

  src = fetchFromGitHub {
    owner = "ryanbinns";
    repo = "ttwatch";
    rev = "f07a12712ed331f1530db3846828641eb0e2f5c5";
    sha256 = "0y27bldmp6w02pjhr2cmy9g6n23vi0q26pil3rd7vbg4qjahxz27";
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
