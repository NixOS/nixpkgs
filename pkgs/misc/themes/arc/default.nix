{ stdenv, fetchFromGitHub, sassc, autoreconfHook, pkgconfig, gtk3
, gnome-themes-standard, gtk-engine-murrine, optipng, inkscape}:

let
  pname = "arc-theme";
in

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  version = "20180715";

  src = fetchFromGitHub {
    owner  = "NicoHood";
    repo   = pname;
    rev    = version;
    sha256 = "1kkfnkiih0i3pds5mgd1v9lrdrp4nh4hk42mw7sa4fpbjff4jh6j";
  };

  preBuild = ''
    # Shut up inkscape's warnings
    export HOME="$NIX_BUILD_ROOT"
  '';

  nativeBuildInputs = [ autoreconfHook pkgconfig sassc optipng inkscape ];
  buildInputs = [ gtk3 ];

  propagatedUserEnvPkgs = [ gnome-themes-standard gtk-engine-murrine ];

  postPatch = ''
    find . -name render-assets.sh |
    while read filename
    do
      substituteInPlace "$filename" \
        --replace "/usr/bin/inkscape" "${inkscape.out}/bin/inkscape" \
        --replace "/usr/bin/optipng" "${optipng.out}/bin/optipng"
    done
    patchShebangs .
  '';

  configureFlags = [ "--disable-unity" ];

  postInstall = ''
    install -Dm644 -t $out/share/doc/${pname}        AUTHORS *.md
  '';

  meta = with stdenv.lib; {
    description = "A flat theme with transparent elements for GTK 3, GTK 2 and Gnome-Shell";
    homepage    = https://github.com/NicoHood/arc-theme;
    license     = licenses.gpl3;
    maintainers = with maintainers; [ simonvandel romildo ];
    platforms   = platforms.linux;
  };
}
