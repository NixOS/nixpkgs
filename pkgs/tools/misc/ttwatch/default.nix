{ stdenv, fetchFromGitHub, cmake, perl, openssl, curl, libusb1 }:

stdenv.mkDerivation rec {
  name = "ttwatch-${version}";
  version = "2017-12-31";

  src = fetchFromGitHub {
    owner = "ryanbinns";
    repo = "ttwatch";
    rev = "a261851d91e3304a47a04995758f6940747bc54a";
    sha256 = "0llcai1yxikh8nvzry71rr1zz365rg0k0lwp24np5w74kzza3kwx";
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
