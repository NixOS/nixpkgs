{ stdenv, fetchFromGitHub, qmake, qtbase }:

stdenv.mkDerivation rec {
  name = "cmst-${version}";
  version = "2018.01.06";

  src = fetchFromGitHub {
    repo = "cmst";
    owner = "andrew-bibb";
    rev = name;
    sha256 = "1a3v7z75ghziymdj2w8603ql9nfac5q224ylfsqfxcqxw4bdip4r";
  };

  nativeBuildInputs = [ qmake ];

  buildInputs = [ qtbase ];

  enableParallelBuilding = true;

  postPatch = ''
    for f in $(find . -name \*.cpp -o -name \*.pri -o -name \*.pro); do
      substituteInPlace $f --replace /etc $out/etc --replace /usr $out
    done
  '';

  meta = {
    description = "QT GUI for Connman with system tray icon";
    homepage = https://github.com/andrew-bibb/cmst;
    maintainers = [ stdenv.lib.maintainers.matejc ];
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.mit;
  };
}
