{ stdenv
, lib
, bash
, bat
, coreutils
, fetchFromGitHub
, findutils
, fzf
, gawk
, git
, gnugrep
, gnused
, tmux
, util-linux
, xdg-utils
}:

stdenv.mkDerivation rec {
  pname = "fzf-git-sh";
  version = "0-unstable-2024-03-17";

  src = fetchFromGitHub {
    owner = "junegunn";
    repo = "fzf-git.sh";
    rev = "e4cba1fcf8aed9a2348e47b0ba64299122b81709";
    hash = "sha256-glI+TldLGGiXyI5ZghaEgjc+2DJCMdmBnho/Z7IgJoE=";
  };

  dontBuild = true;

  postPatch = ''
    sed -i \
      -e "s,\bawk\b,${gawk}/bin/awk," \
      -e "s,\bbash\b,${bash}/bin/bash," \
      -e "s,\bbat\b,${bat}/bin/bat," \
      -e "s,\bcat\b,${coreutils}/bin/cat," \
      -e "s,\bcut\b,${coreutils}/bin/cut," \
      -e "s,\bhead\b,${coreutils}/bin/head," \
      -e "s,\buniq\b,${coreutils}/bin/uniq," \
      -e "s,\bcolumn\b,${util-linux}/bin/column," \
      -e "s,\bfzf-tmux\b,${fzf}/bin/fzf-tmux," \
      -e "/display-message/!s,\bgit\b,${git}/bin/git,g" \
      -e "s,\bgrep\b,${gnugrep}/bin/grep," \
      -e "s,\bsed\b,${gnused}/bin/sed," \
      -e "/fzf-tmux/!s,\btmux\b,${tmux}/bin/tmux," \
      -e "s,\bxargs\b,${findutils}/bin/xargs," \
      -e "s,\bxdg-open\b,${xdg-utils}/bin/xdg-open," \
      -e "s,__fzf_git=.*BASH_SOURCE.*,__fzf_git=$out/share/${pname}/fzf-git.sh," \
      -e "/__fzf_git=.*readlink.*/d" \
      fzf-git.sh
  '';

  installPhase = ''
    install -D fzf-git.sh $out/share/${pname}/fzf-git.sh
  '';

  meta = with lib; {
    homepage = "https://github.com/junegunn/fzf-git.sh";
    description = "Bash and zsh key bindings for Git objects, powered by fzf";
    license = licenses.mit;
    maintainers = with maintainers; [ deejayem ];
    platforms = platforms.all;
  };
}
