{ stdenv, fetchFromGitHub, gtk3, sassc }:

stdenv.mkDerivation rec {
  name = "tetra-gtk-theme-${version}";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner  = "hrdwrrsk";
    repo   = "tetra-gtk-theme";
    rev    = version;
    sha256 = "1lzkmswv3ml2zj80z067j1hj1cvpdcl86jllahqx3jwnmr0a4fhd";
  };

  preBuild = ''
    # Shut up inkscape's warnings
    export HOME="$NIX_BUILD_ROOT"
  '';

  nativeBuildInputs = [ sassc ];
  buildInputs = [ gtk3 ];

  postPatch = "patchShebangs .";

  installPhase = ''
    mkdir -p $out/share/themes
    ./install.sh -d $out/share/themes
  '';

  meta = with stdenv.lib; {
    description = "Adwaita-based gtk+ theme with design influence from elementary OS and Vertex gtk+ theme.";
    homepage    = https://github.com/hrdwrrsk/tetra-gtk-theme;
    license     = licenses.gpl3;
    maintainers = with maintainers; [ dtzWill ];
    platforms   = platforms.linux;
  };
}
