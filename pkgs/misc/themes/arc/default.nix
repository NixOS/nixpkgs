{ stdenv, fetchFromGitHub, sassc, autoreconfHook, pkgconfig, gtk3, gnome3
, gtk-engine-murrine, optipng, inkscape }:

stdenv.mkDerivation rec {
  pname = "arc-theme";
  version = "20190330";

  src = fetchFromGitHub {
    owner  = "NicoHood";
    repo   = pname;
    rev    = version;
    sha256 = "16n5svgkpa8azxgyy64zwjjc04r57wfzkdq9igqvbvwkbvx8aa89";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkgconfig
    sassc
    optipng
    inkscape
    gtk3
    gnome3.gnome-shell
  ];

  propagatedUserEnvPkgs = [
    gnome3.gnome-themes-extra
    gtk-engine-murrine
  ];

  enableParallelBuilding = true;

  postPatch = ''
    patchShebangs .
    # TODO: remove this after update
    ln -s 3.30 common/gnome-shell/3.32
  '';

  preBuild = ''
    # Shut up inkscape's warnings about creating profile directory
    export HOME="$NIX_BUILD_ROOT"
  '';

  configureFlags = [ "--disable-unity" ];

  postInstall = ''
    install -Dm644 -t $out/share/doc/${pname} AUTHORS *.md
  '';

  meta = with stdenv.lib; {
    description = "A flat theme with transparent elements for GTK 3, GTK 2 and Gnome-Shell";
    homepage    = https://github.com/NicoHood/arc-theme;
    license     = licenses.gpl3;
    maintainers = with maintainers; [ simonvandel romildo ];
    platforms   = platforms.linux;
  };
}
