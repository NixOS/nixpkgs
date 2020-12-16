{ fetchFromGitHub
, pkgs
}:

pkgs.stdenv.mkDerivation rec {
  pname = "nvimpager";
  version = "0.9";

  src = fetchFromGitHub {
    owner = "lucc";
    repo = pname;
    rev = "v${version}";
    sha256 = "1xy5387szfw0bp8dr7d4z33wd4xva7q219rvz8gc0vvv1vsy73va";
  };

  buildInputs = with pkgs; [
    ncurses # for tput
    neovim
    procps # for nvim_get_proc() which uses ps(1)
    pandoc
  ];

  makeFlags = [ "PREFIX=$(out)" ];
  buildFlags = [ "nvimpager.configured" ];
  preBuild = ''
    patchShebangs nvimpager
    substituteInPlace nvimpager --replace ':-nvim' ':-${pkgs.neovim}/bin/nvim'
    '';

  # Defaults to false until I find out how to provide /dev/tty inside the
  # sandbox.
  doCheck = false;
  checkInputs = with pkgs; [ lua51Packages.busted ];
  checkPhase = "busted --lpath './?.lua' test";

  meta = with pkgs.stdenv.lib; {
    description = "Use neovim as pager";
    longDescription = ''
      Use neovim as a pager to view manpages, diffs, etc with nvim's syntax
      highlighting.  Includes a cat mode to print highlighted files to stdout
      and a ansi esc mode to highlight ansi escape sequences in neovim.
    '';
    homepage = "https://github.com/lucc/nvimpager";
    license = licenses.bsd2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ lucc ];
  };
}
