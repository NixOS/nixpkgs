{ stdenv, fetchFromGitHub, qmake, libXxf86vm, wrapQtAppsHook }:

let
  pname = "gammy";
  version = "0.9.58a";
in

stdenv.mkDerivation {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "Fushko";
    repo = pname;
    rev = "v${version}";
    sha256 = "02kwfzh7h2dbsfb6b3qlsc7zga1hq21qvg45wf22vm03mahc28za";
  };

  nativeBuildInputs = [ qmake wrapQtAppsHook ];

  buildInputs = [ libXxf86vm ];

  # FIXME remove when https://github.com/Fushko/gammy/issues/45 is fixed
  installPhase = ''
    runHook preInstall

    install gammy -Dt $out/bin/

    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description = "GUI tool for manual- of auto-adjusting of brightness/temperature";
    homepage = "https://github.com/Fushko/gammy";
    license = licenses.gpl3;
    maintainers = with maintainers; [ atemu ];
    platforms = platforms.linux;
  };
}
