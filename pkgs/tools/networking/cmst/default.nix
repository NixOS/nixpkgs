{ stdenv, fetchFromGitHub, qmake, qtbase, libX11 }:

stdenv.mkDerivation rec {
  name = "cmst-${version}";
  version = "2017.09.19";

  src = fetchFromGitHub {
    repo = "cmst";
    owner = "andrew-bibb";
    rev = name;
    sha256 = "14inss0mr9i4q6vfqqfxbjgpjaclp1kh60qlm5xv4cwnvi395rc7";
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
