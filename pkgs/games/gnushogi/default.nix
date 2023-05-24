{ lib, stdenv, fetchurl, zlib }:

stdenv.mkDerivation rec {
  pname = "gnushogi";
  version = "1.4.2";
  buildInputs = [ zlib ];

  src = fetchurl {
    url = "mirror://gnu/gnushogi/${pname}-${version}.tar.gz";
    sha256 = "0a9bsl2nbnb138lq0h14jfc5xvz7hpb2bcsj4mjn6g1hcsl4ik0y";
  };

  env.LDFLAGS = lib.optionalString (!stdenv.isDarwin) "-Wl,-z,muldefs";

  # Makefile ignores errors, so the build may silently succeed erroneously
  postBuild = ''
    test -e gnushogi/gnushogi || { echo "ERROR: no binary produced"; exit 1; }
  '';

  meta = with lib; {
    description = "GNU implementation of Shogi, also known as Japanese Chess";
    homepage = "https://www.gnu.org/software/gnushogi/";
    license = licenses.gpl3;
    maintainers = [ maintainers.ciil ];
    platforms = platforms.unix;
    broken = stdenv.isDarwin; # darwin does not support -z muldefs
  };
}
