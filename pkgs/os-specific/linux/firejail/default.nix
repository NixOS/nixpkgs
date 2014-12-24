{stdenv, fetchurl}:
let
  s = # Generated upstream information
  rec {
    baseName="firejail";
    version="0.9.18";
    name="${baseName}-${version}";
    hash="0qsjbnx9xzvzcbq7wdcf51v5abi4ml9jsai7w6xmns51qx4325a2";
    url="mirror://sourceforge/project/firejail/firejail/firejail-0.9.18-rc1.tar.bz2";
    sha256="0qsjbnx9xzvzcbq7wdcf51v5abi4ml9jsai7w6xmns51qx4325a2";
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
