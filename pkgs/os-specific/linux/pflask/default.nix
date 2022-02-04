{ lib, stdenv, fetchFromGitHub, python2, wafHook }:

stdenv.mkDerivation rec {
  pname = "pflask";
  version = "unstable-2015-12-17";

  src = fetchFromGitHub {
    owner = "ghedo";
    repo = "pflask";
    rev = "599418bb6453eaa0ccab493f9411f13726c1a636";
    hash = "sha256-0RjitZd2JUK7WUEJuw4qhUx3joY5OI0Hh74mTzp7GmY=";
  };

  nativeBuildInputs = [ wafHook ];
  buildInputs = [ python2 ];

  meta = {
    description = "Lightweight process containers for Linux";
    homepage = "https://ghedo.github.io/pflask/";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ ];
  };
}
