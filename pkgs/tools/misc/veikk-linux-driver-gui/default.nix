{
  lib,
  mkDerivation,
  fetchFromGitHub,
  qmake,
}:

mkDerivation rec {
  pname = "veikk-linux-driver-gui";
  version = "2.0";

  src = fetchFromGitHub {
    owner = "jlam55555";
    repo = pname;
    rev = "v${version}";
    sha256 = "02g1q79kwjlzg95w38a1d7nxvcry8xcsvhax2js4c7xqvzhkki5j";
  };

  nativeBuildInputs = [ qmake ];

  postBuild = ''
    make all clean
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp veikk-linux-driver-gui $out/bin
  '';

  meta = with lib; {
    description = "Configuration tool for the VEIKK Linux driver";
    homepage = "https://github.com/jlam55555/veikk-linux-driver-gui/";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ nicbk ];
    mainProgram = "veikk-linux-driver-gui";
  };
}
