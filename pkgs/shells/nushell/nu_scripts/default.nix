{ lib
, stdenvNoCC
, fetchFromGitHub
}:

stdenvNoCC.mkDerivation rec {
  pname = "nu_scripts";
  version = "unstable-2023-03-16";

  src = fetchFromGitHub {
    owner = "nushell";
    repo = pname;
    rev = "00b0039653be5dd2e6567ce8feea82064d27ae11";
    sha256 = "0m17cj5wzp94f01kwgs1dh76zwsl2irr7b06i9sb5skqxmmdnjnz";
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
