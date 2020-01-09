{ stdenv, fetchFromGitHub
, python3
, popt
}:

stdenv.mkDerivation rec {
  pname = "isomd5sum";
  version = "1.2.3";

  src = fetchFromGitHub {
    owner = "rhinstaller";
    repo = pname;
    rev = version;
    sha256 = "1wjnh2hlp1hjjm4a8wzdhdrm73jq41lmpmy3ls0rh715p3j7z4q9";
  };

  buildInputs = [ python3 popt ] ;

  postPatch = ''
    substituteInPlace Makefile --replace "#/usr/" "#"
    substituteInPlace Makefile --replace "/usr/" "/"
  '';

  dontConfigure = true;

  makeFlags = [ "DESTDIR=${placeholder "out"}" ];

  # we don't install python stuff as it borks up directories
  installTargets = [ "install-bin" "install-devel" ];

  meta = with stdenv.lib; {
    homepage = https://github.com/rhinstaller/isomd5sum;
    description = "Utilities for working with md5sum implanted in ISO images";
    platforms = platforms.linux;
    license = licenses.gpl2;
    maintainers = with maintainers; [ knl ];
  };
}
