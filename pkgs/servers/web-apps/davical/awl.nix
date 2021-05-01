{ stdenv, lib, gettext, fetchFromGitLab }:

stdenv.mkDerivation rec {
  version = "0.62";
  pname = "awl";

  src = fetchFromGitLab {
    owner = "davical-project";
    repo = "awl";
    rev = "r${version}";
    sha256 = "0nm0vx7invs5fplgb7c70xyww6729l1vrzq93sql1qwmdmjy34zw";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/awl
    cp -r * $out/share/awl

    runHook postInstall
  '';

  buildInputs = [ gettext ];

  meta = with lib; {
    description = "Andrew's Web Libraries";
    license = licenses.gpl2Plus;
    homepage = "https://gitlab.com/davical-project/awl";
    platforms = platforms.all;
    maintainers = with maintainers; [ henson ];
  };

}
