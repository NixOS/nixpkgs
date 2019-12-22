{ stdenv, fetchFromGitHub, libusb, gitMinimal }:

stdenv.mkDerivation rec {
  pname = "xow";
  version = "0.2";

  src = fetchFromGitHub {
    owner = "medusalix";
    repo = "xow";
    rev = "v${version}";
    sha256 = "03ajal91xi52svzy621aa4jcdf0vj4pqd52kljam0wryrlmcpbr3";
  };

  makeFlags = [ "BUILD=RELEASE" "VERSION=${version}" ];
  enableParallelBuilding = true;
  buildInputs = [ libusb ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp xow $out/bin
    runHook postInstall
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/medusalix/xow";
    description = "Linux driver for the Xbox One wireless dongle";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.pmiddend ];
    platforms = platforms.linux;
  };
}
