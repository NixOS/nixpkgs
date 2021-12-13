{ lib, stdenv, fetchFromGitHub, libpng, zlib } :

stdenv.mkDerivation rec {
  pname = "fbgrab";
  version = "1.5";

  src = fetchFromGitHub {
    owner = "GunnarMonell";
    repo = pname;
    rev = version;
    sha256 = "1npn7l8jg0nhjraybjl38v8635zawzmn06ql3hs3vhci1vi1r90r";
  };

  buildInputs = [
    libpng
    zlib
  ];

  preConfigure = ''
    substituteInPlace Makefile \
      --replace "/usr/bin/" "/bin/" \
      --replace "/usr/share/" "/share/"
  '';

  makeFlags = [ "DESTDIR=$(out)" ];

  meta = with lib; {
    homepage = "https://github.com/GunnarMonell/fbgrab";
    description = "Linux framebuffer screenshot utility";
    license = licenses.gpl2Only;
    maintainers = [ maintainers.davidak ];
    platforms = platforms.linux;
  };
}
