{ lib
, stdenvNoCC
, fetchFromGitHub
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "pgf";
  version = "1.18";

  src = fetchFromGitHub {
    owner = "pgf-tikz";
    repo = "pgf";
    rev = "refs/tags/version-${lib.replaceStrings ["."] ["-"] finalAttrs.version}";
    hash = "sha256-WZ/191iEDd5VK1bnV9JZx2BZfACUeAUhAqrlyx+ZvA4=";
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/texmf-nix
    cp -prd context doc generic latex plain $out/share/texmf-nix/

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/pgf-tikz/pgf";
    description = "A Portable Graphic Format for TeX - version ${finalAttrs.version}";
    branch = lib.versions.major version;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.unix;
  };
})
