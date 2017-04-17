{ stdenv, fetchFromGitHub, autoreconfHook, libX11 }:

stdenv.mkDerivation rec {
  name = "xrectsel-${version}";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "lolilolicon";
    repo = "xrectsel";
    rev = "${version}";
    sha256 = "0prl4ky3xzch6xcb673mcixk998d40ngim5dqc5374b1ls2r6n7l";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ libX11 ];

  postBuild = ''
    make install
  '';

  meta = with stdenv.lib; {
    description = "Print the geometry of a rectangular screen region";
    homepage = https://github.com/lolilolicon/xrectsel;
    license = licenses.gpl3;
    maintainers = [ maintainers.guyonvarch ];
    platforms = platforms.linux;
  };
}
