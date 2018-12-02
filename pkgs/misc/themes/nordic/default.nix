{ stdenv, fetchurl, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  name = "nordic-${version}";
  version = "1.3.0";

  srcs = [
    (fetchurl {
      url = "https://github.com/EliverLara/Nordic/releases/download/v${version}/Nordic.tar.xz";
      sha256 = "04axs2yldppcx159nwj70g4cyw0hbbzk5250677i9ny8b0w3gr9x";
    })
    (fetchurl {
      url = "https://github.com/EliverLara/Nordic/releases/download/v${version}/Nordic-standard-buttons.tar.xz";
      sha256 = "1h0690cijaipidb5if2bxhvvkrx5src3akyxvfywxg4bf8x7jxs5";
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
