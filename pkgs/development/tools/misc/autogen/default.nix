{ stdenv, buildPackages, fetchurl, which, pkgconfig, perl, guile, libxml2 }:

stdenv.mkDerivation rec {
  name = "autogen-${version}";
  version = "5.18.12";

  src = fetchurl {
    url = "mirror://gnu/autogen/rel${version}/autogen-${version}.tar.xz";
    sha256 = "1n5zq4872sakvz9c7ncsdcfp0z8rsybsxvbmhkpbd19ii0pacfxy";
  };

  outputs = [ "bin" "dev" "lib" "out" "man" "info" ];

  nativeBuildInputs = [ which pkgconfig perl ]
    # autogen needs a build autogen when cross-compiling
    ++ stdenv.lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
      buildPackages.buildPackages.autogen buildPackages.texinfo ];
  buildInputs = [
    guile libxml2
  ];

  configureFlags = stdenv.lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    "--with-libxml2=${libxml2.dev}"
    "--with-libxml2-cflags=-I${libxml2.dev}/include/libxml2"
    # the configure check for regcomp wants to run a host program
    "libopts_cv_with_libregex=yes"
    #"MAKEINFO=${buildPackages.texinfo}/bin/makeinfo"
  ];

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
    homepage = https://www.gnu.org/software/autogen/;
    platforms = platforms.all;
    maintainers = [ ];
  };
}
