{ stdenv, fetchurl, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  name = "nordic-${version}";
  version = "1.2.1";

  srcs = [
    (fetchurl {
      url = "https://github.com/EliverLara/Nordic/releases/download/v${version}/Nordic.tar.xz";
      sha256 = "1k8fzvjb92wcqha378af5hk6r75xanff9iwlx51jmi67ny8z28pn";
    })
    (fetchurl {
      url = "https://github.com/EliverLara/Nordic/releases/download/v${version}/Nordic-standard-buttons.tar.xz";
      sha256 = "12w01z88rqkds1wm2kskql1x5c6prpgpc9cxxnl0b11knsfhi6jn";
    })
  ];

  sourceRoot = ".";

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  installPhase = ''
    mkdir -p $out/share/themes
    cp -a Nordic* $out/share/themes
    rm $out/share/themes/*/{LICENSE,README.md}
  '';

  meta = with stdenv.lib; {
    description = "Dark Gtk theme created using the awesome Nord color pallete";
    homepage = https://github.com/EliverLara/Nordic;
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = [ maintainers.romildo ];
  };
}
