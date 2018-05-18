{ stdenv, fetchzip }:

let
  version = "0.98";

in fetchzip {
  name = "onestepback-${version}";

  url = "http://www.vide.memoire.free.fr/perso/OneStepBack/OneStepBack-v${version}.zip";

  postFetch = ''
    mkdir -p $out/share/themes
    unzip $downloadedFile -x OneStepBack/LICENSE -d $out/share/themes
  '';

  sha256 = "0sjacvx7020lzc89r5310w83wclw96gzzczy3mss54ldkgmnd0mr";

  meta = with stdenv.lib; {
    description = "Gtk theme inspired by the NextStep look";
    homepage = https://www.opendesktop.org/p/1013663/;
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = [ maintainers.romildo ];
  };
}
