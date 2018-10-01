{ stdenv, fetchFromGitHub, gtk3, sassc, optipng, inkscape, which }:

let
  pname = "tetra-gtk-theme";
in

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  version = "0.1.6";

  src = fetchFromGitHub {
    owner  = "hrdwrrsk";
    repo   = pname;
    rev    = version;
    sha256 = "0jdgj7ac9842cgrjnzdqlf1f3hlf9v7xk377pvqcz2lwcr1dfaxz";
  };

  preBuild = ''
    # Shut up inkscape's warnings
    export HOME="$NIX_BUILD_ROOT"
  '';

  nativeBuildInputs = [ sassc optipng inkscape which ];
  buildInputs = [ gtk3 ];

  postPatch = "patchShebangs .";

  buildPhase = "./render-assets.sh";

  installPhase = "./install.sh -d $out";

  meta = with stdenv.lib; {
    description = "Adwaita-based gtk+ theme with design influence from elementary OS and Vertex gtk+ theme.";
    homepage    = https://github.com/hrdwrrsk/tetra-gtk-theme;
    license     = licenses.gpl3;
    maintainers = with maintainers; [ dtzWill ];
    platforms   = platforms.linux;
  };
}
