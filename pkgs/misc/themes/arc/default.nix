{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, gnome3, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "arc-theme";
  version = "2016-10-13";

  src = fetchFromGitHub {
    owner = "horst3180";
    repo = pname;
    rev = "a9ce9d56ae61f23592fa4a8c200085dde7b43e07";
    sha256 = "02w8nckd4q548shdgml9ndnbnq1g7nq6v8df89mx4l3lc9r6354y";
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
    homepage = "https://github.com/horst3180/arc-theme";
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ simonvandel romildo ];
  };
}
