{ libX11, libXfixes, lib, stdenv, fetchFromGitHub }:
stdenv.mkDerivation rec {
  pname = "clipnotify";
  version = "unstable-2018-02-20";

  src = fetchFromGitHub {
    owner = "cdown";
    repo = "clipnotify";
    rev = "9cb223fbe494c5b71678a9eae704c21a97e3bddd";
    sha256 = "1x9avjq0fgw0svcbw6b6873qnsqxbacls9sipmcv86xia4bxh8dn";
  };

  buildInputs = [ libX11 libXfixes ];

  installPhase = ''
    mkdir -p $out/bin
    cp clipnotify $out/bin
  '';

  meta = with lib; {
    description = "Notify on new X clipboard events";
    inherit (src.meta) homepage;
    maintainers = with maintainers; [ jb55 ];
    license = licenses.publicDomain;
    mainProgram = "clipnotify";
  };
}
