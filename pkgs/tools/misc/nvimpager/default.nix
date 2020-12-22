{ fetchFromGitHub
, stdenv
, ncurses, neovim, procps
, pandoc, lua51Packages, util-linux
}:

stdenv.mkDerivation rec {
  pname = "nvimpager";
  version = "0.9";

  src = fetchFromGitHub {
    owner = "lucc";
    repo = pname;
    rev = "v${version}";
    sha256 = "1xy5387szfw0bp8dr7d4z33wd4xva7q219rvz8gc0vvv1vsy73va";
  };

  buildInputs = [
    ncurses # for tput
    procps # for nvim_get_proc() which uses ps(1)
  ];
  nativeBuildInputs = [ pandoc ];

  makeFlags = [ "PREFIX=$(out)" ];
  buildFlags = [ "nvimpager.configured" ];
  preBuild = ''
    patchShebangs nvimpager
    substituteInPlace nvimpager --replace ':-nvim' ':-${neovim}/bin/nvim'
    '';

  doCheck = true;
  checkInputs = [ lua51Packages.busted util-linux neovim ];
  checkPhase = ''script -c "busted --lpath './?.lua' test"'';

  meta = with stdenv.lib; {
    description = "Use neovim as pager";
    longDescription = ''
      Use neovim as a pager to view manpages, diffs, etc with nvim's syntax
      highlighting.  Includes a cat mode to print highlighted files to stdout
      and a ansi esc mode to highlight ansi escape sequences in neovim.
    '';
    homepage = "https://github.com/lucc/nvimpager";
    license = licenses.bsd2;
    platforms = platforms.unix;
    maintainers = [ maintainers.lucc ];
  };
}
