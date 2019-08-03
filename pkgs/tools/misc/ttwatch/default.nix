{ stdenv, fetchFromGitHub, cmake, perl, openssl, curl, libusb1
, enableUnsafe ? false }:

stdenv.mkDerivation rec {
  name = "ttwatch-${version}";
  version = "2018-12-04";

  src = fetchFromGitHub {
    owner = "ryanbinns";
    repo = "ttwatch";
    rev = "eeb4e19bf7ca7ca2cee7f5fbeb483b27198d86a1";
    sha256 = "18384apdkq35120cgmda686d293354aibwcq2hwhvvjmnq49fnzr";
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
