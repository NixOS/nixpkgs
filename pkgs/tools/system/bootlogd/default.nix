{ stdenv, lib, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "bootlogd";
  version = "2.95.2";

  src = fetchFromGitHub {
    owner = "mobile-nixos";
    repo = "bootlogd";
    rev = "v${version}";
    sha256 = "1i8ypigwvqd0scba4r6c1a5pavb5w0jcz73gicm51lyfz5f9rqp9";
  };

  sourceRoot = "source/src";

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  meta = with lib; {
    license = licenses.gpl2Plus;
    description = "Early logs multiplexer";
    homepage = "https://github.com/mobile-nixos/bootlogd";
    maintainers = [ maintainers.samueldr ];
    platforms = platforms.linux;
  };
}
