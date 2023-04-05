{ lib, stdenv, fetchFromGitLab, perl }:

stdenv.mkDerivation rec {
  pname = "timelimit";
  version = "1.9.2";

  src = fetchFromGitLab {
    owner = "timelimit";
    repo = pname;
    rev = "release/${version}";
    sha256 = "sha256-5IEAF8zCKaCVH6BAxjoa/2rrue9pRGBBkFzN57d+g+g=";
  };

  nativeCheckInputs = [ perl ];
  doCheck = true;

  installFlags = [ "PREFIX=$(out)" ];
  INSTALL_PROGRAM = "install -m755";
  INSTALL_DATA = "install -m644";

  meta = with lib; {
    description = "Execute a command and terminates the spawned process after a given time with a given signal";
    homepage = "https://devel.ringlet.net/sysutils/timelimit/";
    license = licenses.bsd2;
    platforms = platforms.all;
    maintainers = with maintainers; [ figsoda ];
  };
}
