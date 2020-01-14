{stdenv, fetchurl, which}:
let
  s = # Generated upstream information
  rec {
    baseName="firejail";
    version="0.9.60";
    name="${baseName}-${version}";
    url="mirror://sourceforge/firejail/firejail/firejail-${version}.tar.xz";
    sha256="1mw2s040wbxaj4lqfm6033wxrxlnix40mqc2bsfran5sj2gxd3sh";
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
    name = "${s.name}.tar.bz2";
  };

  prePatch = ''
    # Allow whitelisting ~/.nix-profile
    substituteInPlace etc/firejail.config --replace \
      '# follow-symlink-as-user yes' \
      'follow-symlink-as-user no'
  '';

  preConfigure = ''
    sed -e 's@/bin/bash@${stdenv.shell}@g' -i $( grep -lr /bin/bash .)
    sed -e "s@/bin/cp@$(which cp)@g" -i $( grep -lr /bin/cp .)
  '';

  preBuild = ''
    sed -e "s@/etc/@$out/etc/@g" -e "/chmod u+s/d" -i Makefile
  '';

  # We need to set the directory for the .local override files to
  # /etc/firejail so we can actually override them
  postInstall = ''
    sed -E -e 's@^include (.*.local)$@include /etc/firejail/\1@g' -i $out/etc/firejail/*.profile
  '';

  # At high parallelism, the build sometimes fails with:
  # bash: src/fsec-optimize/fsec-optimize: No such file or directory
  enableParallelBuilding = false;

  meta = {
    inherit (s) version;
    description = ''Namespace-based sandboxing tool for Linux'';
    license = stdenv.lib.licenses.gpl2Plus ;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
    homepage = https://l3net.wordpress.com/projects/firejail/;
    downloadPage = "https://sourceforge.net/projects/firejail/files/firejail/";
  };
}
