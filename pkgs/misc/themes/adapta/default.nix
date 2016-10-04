{ stdenv, fetchFromGitHub, autoreconfHook, sass, inkscape, glib, which, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  name = "adapta-gtk-theme-${version}";
  version = "3.21.3.68";

  meta = with stdenv.lib; {
    description = "An adaptive GTK+ theme based on Material Design";
    homepage = "https://github.com/tista500/Adapta";
    license = with licenses; [ gpl2 cc-by-sa-30 ];
    platforms = platforms.linux;
    maintainers = [ maintainers.SShrike ];
  };

  src = fetchFromGitHub {
    owner = "tista500";
    repo = "Adapta";
    rev = version;
    sha256 = "0wwsmsyxfdgsc7fj1kn4r9zsgs09prizwkjljmirwrfdm6j3387p";
  };

  preferLocalBuild = true;
  buildInputs = [ gtk-engine-murrine ];
  nativeBuildInputs = [ autoreconfHook sass inkscape glib.dev which ];

  postPatch = "patchShebangs .";

  configureFlags = "--enable-chrome --disable-unity";
}
