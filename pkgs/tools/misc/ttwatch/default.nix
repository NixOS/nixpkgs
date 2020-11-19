{ stdenv, fetchFromGitHub
, cmake, perl, pkgconfig
, openssl, curl, libusb1, protobufc
, enableUnsafe ? false }:

stdenv.mkDerivation {
  pname = "ttwatch";
  version = "2020-02-05";

  src = fetchFromGitHub {
    owner = "ryanbinns";
    repo = "ttwatch";
    rev = "bfdf1372515574e1fb3871dc1039f8d8a5dbdada";
    sha256 = "07nd4dbkchxy8js1h1f6pzn63pls2afww97wyiiw6zid43mpqyg4";
  };

  nativeBuildInputs = [ cmake perl pkgconfig ];
  buildInputs = [ openssl curl libusb1 protobufc ];

  cmakeFlags = stdenv.lib.optional enableUnsafe [ "-Dunsafe=on" ];

  preFixup = ''
    chmod +x $out/bin/ttbin2mysports
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/ryanbinns/ttwatch";
    description = "Linux TomTom GPS Watch Utilities";
    maintainers = with maintainers; [ dotlambda ];
    license = licenses.mit;
    platforms = with platforms; linux;
  };
}
