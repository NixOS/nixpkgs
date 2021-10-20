{ fetchFromGitHub
, lib, stdenv
, ncurses, neovim, procps
, scdoc, lua51Packages, util-linux
}:

stdenv.mkDerivation rec {
  pname = "nvimpager";
  version = "0.10";

  src = fetchFromGitHub {
    owner = "lucc";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-okYnPwuxU/syxcKIMUBc25r791D6Bug2w2axH4vvmAY=";
  };

  buildInputs = [
    ncurses # for tput
    procps # for nvim_get_proc() which uses ps(1)
  ];
  nativeBuildInputs = [ scdoc ];

  makeFlags = [ "PREFIX=$(out)" ];
  buildFlags = [ "nvimpager.configured" "nvimpager.1" ];
  preBuild = ''
    patchShebangs nvimpager
    substituteInPlace nvimpager --replace ':-nvim' ':-${neovim}/bin/nvim'
    # remove git command from makefile as we run from a tarball
    # replace with actual timestamp of the commit
    substituteInPlace makefile --replace '$(shell git log -1 --no-show-signature --pretty="%ct")' 1623019602
    '';

  doCheck = true;
  checkInputs = [ lua51Packages.busted util-linux neovim ];
  checkPhase = ''
    runHook preCheck
    script -c "busted --lpath './?.lua' test"
    runHook postCheck
  '';

  meta = with lib; {
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
