{ lib
, stdenvNoCC
, fetchFromGitHub
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "pgf";
  version = "2.10";

  src = fetchFromGitHub {
    owner = "pgf-tikz";
    repo = "pgf";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-AA+XFhEkJifODJb6SppnxhR4lMlMNaH+k10UF6QisJ8=";
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
    description = "A Portable Graphic Format for TeX";
    branch = lib.versions.major version;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.unix;
  };
})
