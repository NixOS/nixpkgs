{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, gnome3, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "arc-theme";
  version = "2016-11-25";

  src = fetchFromGitHub {
    owner = "horst3180";
    repo = pname;
    rev = "d641d3de1641a9aa0a0f6ac1bacec91d9fdd3326";
    sha256 = "06ysd19bpqsng2bp2gqzn0wpjhldxgwvlzngrs6mkm9hr7ky5z00";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];

  buildInputs = [ gtk-engine-murrine ];

  preferLocalBuild = true;

  configureFlags = [ "--disable-unity" "--with-gnome=${gnome3.version}" ];

  postInstall = ''
    mkdir -p $out/share/plank/themes
    cp -r extra/*-Plank $out/share/plank/themes
    mkdir -p $out/share/doc/$pname/Chrome
    cp -r extra/Chrome/*.crx $out/share/doc/$pname/Chrome
    cp AUTHORS README.md $out/share/doc/$pname/
  '';

  meta = with stdenv.lib; {
    description = "A flat theme with transparent elements for GTK 3, GTK 2 and Gnome-Shell";
    homepage = https://github.com/horst3180/arc-theme;
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ simonvandel romildo ];
  };
}
