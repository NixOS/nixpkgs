{ stdenv, xorg, fontDirs }:

stdenv.mkDerivation {
  name = "xquartz-system-fonts";
  buildInputs = [
    xorg.mkfontdir xorg.mkfontscale
  ];
  buildCommand = ''
    source $stdenv/setup

    for i in ${toString fontDirs} ; do
      if [ -d $i/ ]; then
        list="$list $i";
      fi;
    done
    list=$(find $list -name fonts.dir -o -name '*.ttf' -o -name '*.otf');
    fontDirs=''';
    for i in $list ; do
      fontDirs="$fontDirs $(dirname $i)";
    done;
    mkdir -p $out/share/X11-fonts/;
    find $fontDirs -type f -o -type l | while read i; do
      j="''${i##*/}"
      if ! test -e "$out/share/X11-fonts/''${j}"; then
        ln -s "$i" "$out/share/X11-fonts/''${j}";
      fi;
    done;
    cd $out/share/X11-fonts/
    rm fonts.dir
    rm fonts.scale
    rm fonts.alias
    mkfontdir
    mkfontscale
    cat $( find ${xorg.fontalias}/ -name fonts.alias) >fonts.alias
  '';
}
