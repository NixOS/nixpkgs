{ lib
, stdenvNoCC
, fetchFromGitHub
}:

stdenvNoCC.mkDerivation rec {
  pname = "nu_scripts";
  version = "unstable-2023-04-26";

  src = fetchFromGitHub {
    owner = "nushell";
    repo = pname;
    rev = "724f89c330dc5b93a2fde29f732cbd5b8d73785c";
    hash = "sha256-aCLFbxVE8/hWsPNPLt2Qn8CaBkYJJLSDgpl6LYvFVYc=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/nu_scripts
    mv ./* $out/share/nu_scripts

    runHook postInstall
  '';

  meta = {
    description = "A place to share Nushell scripts with each other";
    homepage = "https://github.com/nushell/nu_scripts";
    license = lib.licenses.free;

    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.CardboardTurkey ];
  };
}
