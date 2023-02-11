{ mkDerivation, lib, fetchFromGitHub, qmake, qtbase, qttools, gitUpdater }:

mkDerivation rec {
  pname = "cmst";
  version = "2022.11.30";

  src = fetchFromGitHub {
    repo = "cmst";
    owner = "andrew-bibb";
    rev = "${pname}-${version}";
    sha256 = "sha256-4zrV+VPtzMVaNjY/t1Fix0bODRMgtC3t+kFM1meNzlA=";
  };

  nativeBuildInputs = [ qmake qttools ];

  buildInputs = [ qtbase ];

  postPatch = ''
    for f in $(find . -name \*.cpp -o -name \*.pri -o -name \*.pro); do
      substituteInPlace $f --replace /etc $out/etc --replace /usr $out
    done
  '';

  passthru.updateScript = gitUpdater {
    rev-prefix = "${pname}-";
  };

  meta = with lib; {
    description = "QT GUI for Connman with system tray icon";
    homepage = "https://github.com/andrew-bibb/cmst";
    maintainers = with maintainers; [ matejc romildo ];
    platforms = platforms.linux;
    license = licenses.mit;
  };
}
