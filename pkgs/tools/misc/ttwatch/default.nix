{ stdenv, fetchFromGitHub, cmake, perl, openssl, curl, libusb1
, enableUnsafe ? false }:

stdenv.mkDerivation rec {
  name = "ttwatch-${version}";
  version = "2018-02-01";

  src = fetchFromGitHub {
    owner = "ryanbinns";
    repo = "ttwatch";
    rev = "b5c54647ed9b640584e53c4c15ee12d210790021";
    sha256 = "136sskz9hnbwp49gxp983mswzgpl8yfc25ni79csbsnwp0k4lb94";
  };

  nativeBuildInputs = [ cmake perl ];
  buildInputs = [ openssl curl libusb1 ];

  cmakeFlags = stdenv.lib.optional enableUnsafe [ "-Dunsafe=on" ];

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
