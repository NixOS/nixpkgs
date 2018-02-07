{stdenv, fetchurl, which}:
let
  s = # Generated upstream information
  rec {
    baseName="firejail";
    version="0.9.52";
    name="${baseName}-${version}";
    hash="0w8l8z4j7iph8fp7rchhnfsrik3f00f9v5xr191fp38fphzcj56s";
    url="https://vorboss.dl.sourceforge.net/project/firejail/firejail/firejail-0.9.52.tar.xz";
    sha256="0w8l8z4j7iph8fp7rchhnfsrik3f00f9v5xr191fp38fphzcj56s";
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

  meta = {
    inherit (s) version;
    description = ''Namespace-based sandboxing tool for Linux'';
    license = stdenv.lib.licenses.gpl2Plus ;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
    homepage = https://l3net.wordpress.com/projects/firejail/;
    downloadPage = "http://sourceforge.net/projects/firejail/files/firejail/";
  };
}
