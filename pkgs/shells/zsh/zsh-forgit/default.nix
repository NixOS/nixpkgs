{ stdenv, lib, bash, fetchFromGitHub, makeWrapper, fzf, git }:

stdenv.mkDerivation rec {
  pname = "zsh-forgit";
  version = "22.12.0";

  src = fetchFromGitHub {
    owner = "wfxr";
    repo = "forgit";
    rev = version;
    sha256 = "0juBNUJW4SU3Cl6ouD+xMYzlCJOL7NAYpueZ6V56/ck=";
  };

  strictDeps = true;

  postPatch = ''
    substituteInPlace forgit.plugin.zsh \
      --replace "\$INSTALL_DIR/bin/git-forgit" "$out/bin/git-forgit"

    substituteInPlace bin/git-forgit \
      --replace "/bin/bash" "${bash}/bin/bash"
  '';

  dontBuild = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    install -D bin/git-forgit $out/bin/git-forgit
    install -D forgit.plugin.zsh $out/share/zsh/${pname}/forgit.plugin.zsh
    wrapProgram $out/bin/git-forgit \
      --prefix PATH : ${lib.makeBinPath [ fzf git ]}

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
