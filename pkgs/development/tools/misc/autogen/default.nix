{ stdenv, fetchurl, which, pkgconfig, perl, guile, libxml2 }:

stdenv.mkDerivation rec {
  name = "autogen-${version}";
  version = "5.18.6";

  src = fetchurl {
    url = "mirror://gnu/autogen/rel${version}/autogen-${version}.tar.xz";
    sha256 = "0sfmmy19k9z0j3f738fyk6ljf6b66410cvd5zzyplxi2683j10qs";
  };

  outputs = [ "dev" "bin" "lib" "out" "man" "info" ];

  nativeBuildInputs = [ which pkgconfig perl ];
  buildInputs = [ guile libxml2 ];

  postPatch = ''
    # Fix a broken sed expression used for detecting the minor
    # version of guile we are using
    sed -i "s,sed '.*-I.*',sed 's/\\\(^\\\| \\\)-I/\\\1/g',g" configure

    substituteInPlace pkg/libopts/mklibsrc.sh --replace /tmp $TMPDIR
  '';

  postInstall = ''
    mkdir -p $dev/bin
    mv $bin/bin/autoopts-config $dev/bin

    for f in $lib/lib/autogen/tpl-config.tlib $out/share/autogen/tpl-config.tlib; do
      sed -e "s|$dev/include|/no-such-autogen-include-path|" -i $f
      sed -e "s|$bin/bin|/no-such-autogen-bin-path|" -i $f
      sed -e "s|$lib/lib|/no-such-autogen-lib-path|" -i $f
    done
  '';

  #doCheck = true; # 2 tests fail because of missing /dev/tty

  meta = with stdenv.lib; {
    description = "Automated text and program generation tool";
    license = with licenses; [ gpl3Plus lgpl3Plus ];
    homepage = http://www.gnu.org/software/autogen/;
    platforms = platforms.all;
    maintainers = [ ];
  };
}
