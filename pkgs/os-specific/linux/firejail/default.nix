{stdenv, fetchurl}:
let
  s = # Generated upstream information
  rec {
    baseName="firejail";
    version="0.9.26";
    name="${baseName}-${version}";
    hash="12n0kj95hfkzv4jir7j9x0mdpg20bq0fgifjsz1dbsmqi2cspdlq";
    url="mirror://sourceforge/firejail/firejail/firejail-0.9.26-rc2.tar.bz2";
    sha256="12n0kj95hfkzv4jir7j9x0mdpg20bq0fgifjsz1dbsmqi2cspdlq";
  };
  buildInputs = [
  ];
in
stdenv.mkDerivation {
  inherit (s) name version;
  inherit buildInputs;
  src = fetchurl {
    inherit (s) url sha256;
  };

  preConfigure = ''
    sed -e 's@/bin/bash@${stdenv.shell}@g' -i $( grep -lr /bin/bash .)
    sed -e '/void fs_var_run(/achar *vrcs = get_link("/var/run/current-system")\;' -i ./src/firejail/fs_var.c
    sed -e '/ \/run/iif(vrcs!=NULL){symlink(vrcs, "/var/run/current-system")\;free(vrcs)\;}' -i ./src/firejail/fs_var.c
  '';

  preBuild = ''
    sed -e "s@/etc/@$out/etc/@g" -i Makefile
  '';

  meta = {
    inherit (s) version;
    description = ''Namespace-based sandboxing tool for Linux'';
    license = stdenv.lib.licenses.gpl2Plus ;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
    homepage = "http://l3net.wordpress.com/projects/firejail/";
    downloadPage = "http://sourceforge.net/projects/firejail/files/firejail/";
  };
}
