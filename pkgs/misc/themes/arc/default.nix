{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, gnome3, gtk-engine-murrine }:

let
  # treat versions newer than 3.22 as 3.22
  gnomeVersion = if stdenv.lib.versionOlder "3.22" gnome3.version then "3.22" else gnome3.version;
  pname = "arc-theme";

in stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  version = "2017-05-12";

  src = fetchFromGitHub {
    owner  = "horst3180";
    repo   = pname;
    rev    = "8290cb813f157a22e64ae58ac3dfb5983b0416e6";
    sha256 = "1lxiw5iq9n62xzs0fks572c5vkz202jigndxaankxb44wcgn9zyf";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];

  buildInputs = [ gtk-engine-murrine gnome3.gtk ];

  preferLocalBuild = true;

  configureFlags = [ "--disable-unity" "--with-gnome=${gnomeVersion}" ];

  postInstall = ''
    mkdir -p $out/share/plank/themes
    cp -r extra/*-Plank $out/share/plank/themes
    mkdir -p $out/share/doc/$pname/Chrome
    cp -r extra/Chrome/*.crx $out/share/doc/$pname/Chrome
    cp AUTHORS README.md $out/share/doc/$pname/
  '';

  meta = with stdenv.lib; {
    description = "A flat theme with transparent elements for GTK 3, GTK 2 and Gnome-Shell";
    homepage    = https://github.com/horst3180/arc-theme;
    license     = licenses.gpl3;
    maintainers = with maintainers; [ simonvandel romildo ];
    platforms   = platforms.unix;
  };
}
