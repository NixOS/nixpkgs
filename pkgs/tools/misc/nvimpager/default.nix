{
  fetchFromGitHub,
  lib,
  stdenv,
  ncurses,
  neovim,
  procps,
  scdoc,
  lua51Packages,
  util-linux,
}:

stdenv.mkDerivation rec {
  pname = "nvimpager";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "lucc";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Au9rRZMZfU4qHi/ng6JO8FnMpySKDbKzr75SBPY3QiA=";
  };

  buildInputs = [
    ncurses # for tput
    procps # for nvim_get_proc() which uses ps(1)
  ];
  nativeBuildInputs = [ scdoc ];

  makeFlags = [ "PREFIX=$(out)" ];
  buildFlags = [
    "nvimpager.configured"
    "nvimpager.1"
  ];
  preBuild = ''
    patchShebangs nvimpager
    substituteInPlace nvimpager --replace-fail ':-nvim' ':-${lib.getExe neovim}'
  '';

  doCheck = true;
  nativeCheckInputs = [
    lua51Packages.busted
    util-linux
    neovim
  ];
  # filter out one test that fails in the sandbox of nix or with neovim v0.10
  # or on macOS
  preCheck = ''
    checkFlagsArray+=('BUSTED=busted --output TAP --exclude-tags=${
      "nix,v10" + lib.optionalString stdenv.isDarwin ",mac"
    }')
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
    mainProgram = "nvimpager";
  };
}
