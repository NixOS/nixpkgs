{ mkDerivation, lib, fetchFromGitHub, qmake, qtbase, qttools }:

mkDerivation rec {
  pname = "cmst";
  version = "2021.12.02";

  src = fetchFromGitHub {
    repo = "cmst";
    owner = "andrew-bibb";
    rev = "${pname}-${version}";
    sha256 = "1561bwc1h62w1zfazcs18aqaz17k5n5gr3jal4aw5cw8dgxhvxcb";
  };

  nativeBuildInputs = [ qmake qttools ];

  buildInputs = [ qtbase ];

  postPatch = ''
    for f in $(find . -name \*.cpp -o -name \*.pri -o -name \*.pro); do
      substituteInPlace $f --replace /etc $out/etc --replace /usr $out
    done
  '';

  preBuild = ''
    lrelease translations/*.ts
  '';

  meta = {
    description = "QT GUI for Connman with system tray icon";
    homepage = "https://github.com/andrew-bibb/cmst";
    maintainers = [ lib.maintainers.matejc ];
    platforms = lib.platforms.linux;
    license = lib.licenses.mit;
  };
}
