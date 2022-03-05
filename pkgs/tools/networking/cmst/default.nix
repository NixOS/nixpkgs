{ mkDerivation, lib, fetchFromGitHub, qmake, qtbase, qttools }:

mkDerivation rec {
  pname = "cmst";
  version = "2022.01.05";

  src = fetchFromGitHub {
    repo = "cmst";
    owner = "andrew-bibb";
    rev = "${pname}-${version}";
    sha256 = "0d05vrsjm30q22wpxicnxhjzrjq5kxjhpb6262m46sgkr8yipfhr";
  };

  nativeBuildInputs = [ qmake qttools ];

  buildInputs = [ qtbase ];

  postPatch = ''
    for f in $(find . -name \*.cpp -o -name \*.pri -o -name \*.pro); do
      substituteInPlace $f --replace /etc $out/etc --replace /usr $out
    done
  '';

  meta = with lib; {
    description = "QT GUI for Connman with system tray icon";
    homepage = "https://github.com/andrew-bibb/cmst";
    maintainers = with maintainers; [ matejc romildo ];
    platforms = platforms.linux;
    license = licenses.mit;
  };
}
