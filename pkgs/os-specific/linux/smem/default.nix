{ lib, stdenv, fetchurl, python }:

stdenv.mkDerivation rec {
  name = "smem-1.4";

  src = fetchurl {
    url = "https://www.selenic.com/smem/download/${name}.tar.gz";
    sha256 = "1v31vy23s7szl6vdrllq9zbg58bp36jf5xy3fikjfg6gyiwgia9f";
  };

  buildInputs = [ python ];

  buildPhase =
    ''
      gcc -O2 smemcap.c -o smemcap
    '';

  installPhase =
    ''
      mkdir -p $out/bin
      cp smem smemcap $out/bin/

      mkdir -p $out/share/man/man8
      cp smem.8 $out/share/man/man8/
    '';

  meta = {
    homepage = http://www.selenic.com/smem/;
    description = "A memory usage reporting tool that takes shared memory into account";
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.eelco ];
    license = lib.licenses.gpl2Plus;
  };
}
