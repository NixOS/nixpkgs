# zsh-git-prompt -- Informative git prompt for zsh
#
# Usage: to enable this plugin for all users, you could
# add it to configuration.nix like this:
#
#   programs.zsh.interactiveShellInit = ''
#     source ${pkgs.zsh-git-prompt}/share/zsh-git-prompt/zshrc.sh
#   '';
#
# Or you can install it globally but only enable it in individual
# users' ~/.zshrc files:
#
#   source /run/current-system/sw/share/zsh-git-prompt/zshrc.sh
#
# Or if installed locally:
#
#   source ~/.nix-profile/share/zsh-git-prompt/zshrc.sh
#
# Either way, you then have to set a prompt that incorporates
# git_super_status, for example:
#
#   PROMPT='%B%m%~%b$(git_super_status) %# '
#
# More details are in share/doc/zsh-git-prompt/README.md, once
# installed.
#
{ fetchgit
, haskell
, python
, git
, lib
, ghcVersion ? "ghc802"
}:

haskell.packages.${ghcVersion}.callPackage
  ({ mkDerivation, base, HUnit, parsec, process, QuickCheck, stdenv }:
   mkDerivation rec {
     pname = "zsh-git-prompt";
     version = "0.5";
     src = fetchgit {
       url = "https://github.com/olivierverdier/zsh-git-prompt.git";
       rev = "0a6c8b610e799040b612db8888945f502a2ddd9d";
       sha256 = "19x1gf1r6l7r6i7vhhsgzcbdlnr648jx8j84nk2zv1b8igh205hw";
     };
     prePatch = ''
        substituteInPlace zshrc.sh                       \
          --replace ':-"python"' ':-"haskell"'           \
          --replace 'python '    '${python.interpreter} ' \
          --replace 'git '       '${git}/bin/git '
     '';
     preCompileBuildDriver = "cd src";
     postInstall = ''
        cd ..
        gpshare=$out/share/${pname}
        gpdoc=$out/share/doc/${pname}
        mkdir -p $gpshare/src $gpdoc
        cp README.md $gpdoc
        cp zshrc.sh gitstatus.py $gpshare
        mv $out/bin $gpshare/src/.bin
     '';
     isLibrary = false;
     isExecutable = true;
     libraryHaskellDepends = [ base parsec process QuickCheck ];
     executableHaskellDepends = libraryHaskellDepends;
     testHaskellDepends = [HUnit] ++ libraryHaskellDepends;
     homepage = "http://github.com/olivierverdier/zsh-git-prompt#readme";
     description = "Informative git prompt for zsh";
     license = stdenv.lib.licenses.mit;
     maintainers = [lib.maintainers.league];
   }) {}
