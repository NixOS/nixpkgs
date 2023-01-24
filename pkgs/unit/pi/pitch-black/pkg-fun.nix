{ lib, stdenvNoCC, fetchFromGitHub }:

stdenvNoCC.mkDerivation rec{
  pname = "pitch-black";
  version = "unstable-2019-07-23";

  src = fetchFromGitHub {
    repo = pname;
    owner = "freefreeno";
    rev = "d8039341419aef1157c030bf3d9237bd926e0b95";
    hash = "sha256-Rn3ZMBD6srIkYFNN3HT5JFP46Akodmeqz5tbV2/2ZDA=";
  };

  dontBuild = true;

  installPhase = ''
    rm LICENSE README.md
    mkdir -p $out/share
    mv GTK $out/share/themes
    mv * $out/share
  '';

  meta = with lib; {
    description = "A dark plasma theme built with usability in mind";
    homepage = "https://github.com/freefreeno/Pitch-Black";
    license = licenses.gpl3Only;
    platforms = platforms.unix;
    maintainers = [ maintainers.pasqui23 ];
  };
}
