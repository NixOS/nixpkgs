{ stdenv, lib, fetchFromGitHub, php }:

stdenv.mkDerivation rec {
  pname = "hotcrp";
  version = "3.0b3";

  src = fetchFromGitHub {
    owner = "kohler";
    repo = "hotcrp";
    rev = "v${version}";
    hash = "sha256-t3/auUMkMEY0FS2R5xu7NnaC5q2ZHRrpSHnBC7274as=";
  };

  installPhase = ''
    runHook preInstall
    cp -r . $out/
  '';


  meta = with lib; {
    description = "HotCRP Conference Review Software";
    homepage = "https://hotcrp.com/";
    sourceProvenance = [ sourceTypes.fromSource ];
    license = licenses.mit;
    maintainers = [ "bollu<siddu.druid@gmail.com>" ];
    mainProgram = "hotcrp";
    platforms = platforms.all;
  };
}
