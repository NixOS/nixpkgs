{stdenv, fetchFromGitHub, lib, ncurses, pkg-config }:

stdenv.mkDerivation rec {
  pname = "iotop-c";
  version = "1.21";

  src = fetchFromGitHub {
    owner = "Tomas-M";
    repo = "iotop";
    rev = "v${version}";
    sha256 = "sha256-Zzm0EV6baQvKPOC762mnieYe1JM7ZfNovKqFQt20jQ8=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ ncurses ];
  makeFlags = [ "DESTDIR=$(out)" "TARGET=iotop-c" ];

  postInstall = ''
    mv $out/usr/share/man/man8/{iotop,iotop-c}.8
    ln -s $out/usr/sbin $out/bin
    ln -s $out/usr/share $out/share
  '';

  meta = with lib; {
    description = "iotop identifies processes that use high amount of input/output requests on your machine";
    homepage = "https://github.com/Tomas-M/iotop";
    maintainers = [ maintainers.arezvov ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
