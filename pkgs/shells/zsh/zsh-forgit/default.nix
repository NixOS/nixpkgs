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
<<<<<<< HEAD
  version = "23.09.0";
=======
  version = "23.05.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "wfxr";
    repo = "forgit";
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-WvJxjEzF3vi+YPVSH3QdDyp3oxNypMoB71TAJ7D8hOQ=";
=======
    sha256 = "sha256-oBPN8ehz00cDIs6mmGfCBzuDQMLG5z3G6KetJ1FK7e8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    install -D completions/_git-forgit $out/share/zsh/site-functions/_git-forgit
    install -D completions/git-forgit.zsh $out/share/zsh/${pname}/git-forgit.zsh
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
