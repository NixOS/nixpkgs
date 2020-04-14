{ stdenv, fetchurl, xz }:

stdenv.mkDerivation rec {
  pname = "gzip";
  version = "1.10";

  src = fetchurl {
    url = "mirror://gnu/gzip/${pname}-${version}.tar.xz";
    sha256 = "1h6p374d3j8d4cdfydzls021xa2yby8myc0h8d6m8bc7k6ncq9c4";
  };

  outputs = [ "out" "man" "info" ];

  enableParallelBuilding = true;

  nativeBuildInputs = [ xz.bin ];

  makeFlags = [ "SHELL=/bin/sh" "GREP=grep" ];

  # Many gzip executables are shell scripts that depend upon other gzip
  # executables being in $PATH.  Rather than try to re-write all the
  # internal cross-references, just add $out/bin to PATH at the top of
  # all the executables that are shell scripts.
  preFixup = ''
    sed -i '1{;/#!\/bin\/sh/aPATH="'$out'/bin:$PATH"
    }' $out/bin/*
  '';

  meta = {
    homepage = "https://www.gnu.org/software/gzip/";
    description = "GNU zip compression program";

    longDescription =
      ''gzip (GNU zip) is a popular data compression program written by
        Jean-loup Gailly for the GNU project.  Mark Adler wrote the
        decompression part.

        We developed this program as a replacement for compress because of
        the Unisys and IBM patents covering the LZW algorithm used by
        compress.  These patents made it impossible for us to use compress,
        and we needed a replacement.  The superior compression ratio of gzip
        is just a bonus.
      '';

    platforms = stdenv.lib.platforms.all;

    license = stdenv.lib.licenses.gpl3Plus;
  };
}
