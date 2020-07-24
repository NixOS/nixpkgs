{ mkDerivation, lib, fetchFromGitHub, qmake, qtbase }:

mkDerivation rec {
  pname = "cmst";
  version = "2019.01.13";

  src = fetchFromGitHub {
    repo = "cmst";
    owner = "andrew-bibb";
    rev = "${pname}-${version}";
    sha256 = "13739f0ddld34dcqlfhylzn1zqz5a7jbp4a4id7gj7pcxjx1lafh";
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
    homepage = "https://github.com/andrew-bibb/cmst";
    maintainers = [ lib.maintainers.matejc ];
    platforms = lib.platforms.linux;
    license = lib.licenses.mit;
  };
}
