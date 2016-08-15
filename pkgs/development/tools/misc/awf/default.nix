{ stdenv, fetchFromGitHub, autoreconfHook, gtk2, gtk3, pkgconfig
, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "awf-${version}";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "valr";
    repo = "awf";
    rev = "v${version}";
    sha256 = "18dqa2269cwr0hrn67vp0ifwbv8vc2xn6mg145pbnc038hicql8m";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig wrapGAppsHook ];

  buildInputs = [ gtk2 gtk3 ];

  autoreconfPhase = ''
    patchShebangs ./autogen.sh
    ./autogen.sh
  '';

  meta = with stdenv.lib; {
    description = "A Widget Factory";
    longDescription = ''
      A widget factory is a theme preview application for gtk2 and
      gtk3. It displays the various widget types provided by gtk2/gtk3
      in a single window allowing to see the visual effect of the
      applied theme.
    '';
    homepage = https://github.com/valr/awf;
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ michalrus ];
  };
}
