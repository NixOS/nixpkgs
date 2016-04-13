{stdenv, fetchurl, which}:
let
  s = # Generated upstream information
  rec {
    baseName="firejail";
    version="0.9.40";
    name="${baseName}-${version}";
    hash="1vr0z694wibjkcpmyg7lz68r53z857c8hsb02cqxi4lfkkcmzgh2";
    url="mirror://sourceforge/project/firejail/firejail/firejail-0.9.40-rc1.tar.bz2";
    sha256="1vr0z694wibjkcpmyg7lz68r53z857c8hsb02cqxi4lfkkcmzgh2";
  };
  buildInputs = [
    which
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
    sed -e "s@/bin/cp@$(which cp)@g" -i $( grep -lr /bin/cp .)
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
