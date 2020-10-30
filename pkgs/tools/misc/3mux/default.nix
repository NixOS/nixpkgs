{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "3mux";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "aaronjanse";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-auEMG3txO2JS/2dMFBtEujv9s5I0A80Vwts5kXjH600=";
  };

  vendorSha256 = "sha256-rcbnyScD2GU1DLY6dTEPgFNXZfgkxXPn5lt6HRqa0d8=";

  meta = with stdenv.lib; {
    description = "Terminal multiplexer inspired by i3";
    longDescription = ''
      3mux is a terminal multiplexer with out-of-the-box support for search,
      mouse-controlled scrollback, and i3-like keybindings. Imagine tmux with a
      smaller learning curve and more sane defaults.
    '';
    homepage = "https://github.com/aaronjanse/3mux";
    license = licenses.mit;
    maintainers = with maintainers; [ aaronjanse filalex77 ];
    platforms = platforms.unix;
  };
}
