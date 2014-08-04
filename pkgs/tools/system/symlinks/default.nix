{ fetchurl, stdenv }:

stdenv.mkDerivation rec {
  name = "symlinks-${version}";
  version = "1.4";

  src = fetchurl {
    url = "http://www.ibiblio.org/pub/Linux/utils/file/${name}.tar.gz";
    sha256 = "1683psyi8jwq6anhnkwwyaf7pfksf19v04fignd6vi52s2fnifxh";
  };

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share/man
    cp symlinks $out/bin/
    cp symlinks.8 $out/share/man/
  '';

  # No license is mentioned in the code but
  # http://www.ibiblio.org/pub/Linux/utils/file/symlinks.lsm
  # and other package managers list it as
  # "(c) Mark Lord, freely distributable"
  meta = with stdenv.lib; {
    description = "A symbolic link maintenance utility";
    maintainers = [ maintainers.goibhniu ];
  };
}
