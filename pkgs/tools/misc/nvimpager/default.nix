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
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "lucc";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-RmpPWS9gnBnR+Atw6uzBmeDSgoTOFSdKzHoJ84O+gyA=";
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
    substituteInPlace nvimpager --replace ':-nvim' ':-${neovim}/bin/nvim'
  '';

  doCheck = true;
  nativeCheckInputs = [
    lua51Packages.busted
    util-linux
    neovim
  ];
  # filter out one test that fails in the sandbox of nix
  checkPhase =
    let
      exclude-tags = if stdenv.isDarwin then "nix,mac" else "nix";
    in
    ''
      runHook preCheck
      make test BUSTED='busted --output TAP --exclude-tags=${exclude-tags}'
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
    mainProgram = "nvimpager";
  };
}
