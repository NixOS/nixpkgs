{ stdenv, fetchFromGitHub, cmake, perl, openssl, curl, libusb1 }:

stdenv.mkDerivation rec {
  name = "ttwatch-${version}";
  version = "2017-09-26";

  src = fetchFromGitHub {
    owner = "ryanbinns";
    repo = "ttwatch";
    rev = "31fb7ca6ac992d131a3f5ea6acf49f0c52a128c5";
    sha256 = "1sxjx593jqbq45jn2dkjz07zq9kkgsbcj971phimlm6dj6g75wxq";
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
