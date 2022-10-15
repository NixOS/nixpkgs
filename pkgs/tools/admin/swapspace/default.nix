{ lib, stdenv, fetchFromGitHub, autoreconfHook, installShellFiles }:

stdenv.mkDerivation rec {
  pname = "swapspace";
  version = "1.18";

  src = fetchFromGitHub {
    owner = "Tookmund";
    repo = "Swapspace";
    rev = "v${version}";
    sha256 = "sha256-tzsw10cpu5hldkm0psWcFnWToWQejout/oGHJais6yw=";
  };

  nativeBuildInputs = [
    autoreconfHook
    installShellFiles
  ];

  postInstall = ''
    installManPage doc/swapspace.8
  '';

  meta = with lib; {
    description = "Dynamic swap manager for Linux";
    homepage = "https://github.com/Tookmund/Swapspace";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ misuzu ];
  };
}
