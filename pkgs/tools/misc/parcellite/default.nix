{ stdenv, fetchFromGitHub, autoreconfHook, makeWrapper
, gtk2, intltool, pkgconfig, which, xdotool }:

stdenv.mkDerivation rec {
  name = "parcellite-${version}";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "rickyrockrat";
    repo = "parcellite";
    rev = version;
    sha256 = "19q4x6x984s6gxk1wpzaxawgvly5vnihivrhmja2kcxhzqrnfhiy";
  };

  nativeBuildInputs = [ autoreconfHook intltool pkgconfig makeWrapper ];
  buildInputs = [ gtk2 ];

  postInstall = ''
    wrapProgram $out/bin/parcellite \
      --prefix PATH : "${which}/bin" \
      --prefix PATH : "${xdotool}/bin"
  '';

  meta = with stdenv.lib; {
    description = "Lightweight GTK+ clipboard manager";
    homepage = https://github.com/rickyrockrat/parcellite;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
