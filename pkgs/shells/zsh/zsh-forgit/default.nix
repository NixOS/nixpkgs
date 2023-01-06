{ stdenv
, lib
, bash
, coreutils
, findutils
, fetchFromGitHub
, fzf
, git
, gnugrep
, gnused
, makeWrapper
}:

stdenv.mkDerivation rec {
  pname = "zsh-forgit";
  version = "23.01.0";

  src = fetchFromGitHub {
    owner = "wfxr";
    repo = "forgit";
    rev = version;
    sha256 = "sha256-guAjxFhtybbRyRRXDELDHrM2Xzmi96wPxD2nhL9Ifmk=";
  };

  strictDeps = true;

  postPatch = ''
    substituteInPlace forgit.plugin.zsh \
      --replace "\$INSTALL_DIR/bin/git-forgit" "$out/bin/git-forgit"
  '';

  dontBuild = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    install -D bin/git-forgit $out/bin/git-forgit
    install -D forgit.plugin.zsh $out/share/zsh/${pname}/forgit.plugin.zsh
    wrapProgram $out/bin/git-forgit \
      --prefix PATH : ${lib.makeBinPath [ bash coreutils findutils fzf git gnugrep gnused ]}

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/wfxr/forgit";
    description = "A utility tool powered by fzf for using git interactively";
    license = licenses.mit;
    maintainers = with maintainers; [ deejayem ];
    platforms = platforms.all;
  };
}
