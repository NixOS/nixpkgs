{ fetchurl, stdenv }:

stdenv.mkDerivation rec {
  name = "numactl-1.0.2";
  src = fetchurl {
    url = "ftp://oss.sgi.com/www/projects/libnuma/download/${name}.tar.gz";
    sha256 = "0hbrrh7a8cradj1xdl3wvyp9afx1hzsk90g2lkwd5pn6bniai31j";
  };

  patchPhase = ''
    sed -i "Makefile" -es"|^ *prefix *:=.*$|prefix := $out|g"
  '';

  preInstall = ''
    # The `install' rule expects this directory to be available.
    mkdir -p "$out/share/man/man5"
  '';

  meta = {
    description = "Library and tools for non-uniform memory access (NUMA) machines";
    license = [ "LGPLv2.1" # library
                "GPLv2"    # command-line tools
	      ];
    homepage = http://oss.sgi.com/projects/libnuma/;
  };
}
