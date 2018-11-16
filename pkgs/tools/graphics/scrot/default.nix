{ stdenv, fetchurl, fetchzip, giblib, xlibsWrapper }:

let
  debPatch = fetchzip {
    url = mirror://debian/pool/main/s/scrot/scrot_0.8-18.debian.tar.xz;
    sha256 = "1m8m8ad0idf3nzw0k57f6rfbw8n7dza69a7iikriqgbrpyvxqybx";
  };
in
stdenv.mkDerivation rec {
  name = "scrot-0.8-18";

  src = fetchurl {
    url = "http://linuxbrit.co.uk/downloads/${name}.tar.gz";
    sha256 = "1wll744rhb49lvr2zs6m93rdmiq59zm344jzqvijrdn24ksiqgb1";
  };

  postPatch = ''
    for patch in $(cat ${debPatch}/patches/series); do
      patch -p1 < "${debPatch}/patches/$patch"
    done
  '';

  buildInputs = [ giblib xlibsWrapper ];

  meta = with stdenv.lib; {
    homepage = http://linuxbrit.co.uk/scrot/;
    description = "A command-line screen capture utility";
    platforms = platforms.linux;
    maintainers = with maintainers; [ garbas ];
    license = licenses.mit;
  };
}
