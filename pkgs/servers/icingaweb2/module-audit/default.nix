{ stdenv, lib, fetchFromGitHub }: with lib; stdenv.mkDerivation rec {
  name = "icingaweb2-module-audit";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "Icinga";
    repo = name;
    rev = "v${version}";
    sha256 = "1klaxd60ba6yg227vjag1pqszdp358a7qr56vzhfp98yj36g4754";
  };

  installPhase = ''
    mkdir -p "$out"
    cp -r * "$out"
  '';

  meta = {
    description = "Audit module for Icingaweb 2";
    homepage = "https://github.com/Icinga/icingaweb2-module-audit";
    license = licenses.gpl2;
    platforms = platforms.all;
    maintainers = with maintainers; [ das_j ];
  };
}
