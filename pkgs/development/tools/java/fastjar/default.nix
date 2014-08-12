{ fetchurl, stdenv, zlib }:

let version = "0.94"; in
  stdenv.mkDerivation rec {
    name = "fastjar-${version}";

    src = fetchurl {
      url = "mirror://sourceforge/fastjar/${version}/${name}.tar.gz";
      sha256 = "15bvhvn2fzpziynk4myg1wl70wxa5a6v65hkzlcgnzh1wg1py8as";
    };

    buildInputs = [ zlib ];

    doCheck = true;

    meta = {
      description = "FastJar, a fast Java archiver written in C";

      longDescription = ''
        Fastjar is a version of Sun's `jar' utility, written entirely in C, and
        therefore quite a bit faster.  Fastjar can be up to 100x faster than
        the stock `jar' program running without a JIT.
      '';

      homepage = http://fastjar.sourceforge.net/;

      license = stdenv.lib.licenses.gpl2Plus;

      maintainers = [ ];
    };
  }
