{ stdenv, buildPackages, fetchurl, autoreconfHook, which, pkgconfig, perl, guile, libxml2 }:

stdenv.mkDerivation rec {
  pname = "autogen";
  version = "5.18.16";

  src = fetchurl {
    url = "mirror://gnu/autogen/rel${version}/autogen-${version}.tar.xz";
    sha256 = "16mlbdys8q4ckxlvxyhwkdnh1ay9f6g0cyp1kylkpalgnik398gq";
  };

  patches = let
    dp = { ver ? "1%255.18.16-4", pname, name ? (pname + ".diff"), sha256 }: fetchurl {
      url = "https://salsa.debian.org/debian/autogen/-/raw/debian/${ver}"
          + "/debian/patches/${pname}.diff?inline=false";
      inherit name sha256;
    };
  in [
    (dp {
      pname = "20_no_Werror";
      sha256 = "08z4s2ifiqyaacjpd9pzr59w8m4j3548kkaq1bwvp2gjn29m680x";
    })
    (dp {
      pname = "30_ag_macros.m4_syntax_error";
      sha256 = "1z8vmbwbkz3505wd33i2xx91mlf8rwsa7klndq37nw821skxwyh3";
    })
    (dp {
      pname = "31_allow_overriding_AGexe_for_crossbuild";
      sha256 = "0h9wkc9bqb509knh8mymi43hg6n6sxg2lixvjlchcx7z0j7p8xkf";
    })
  ];

  outputs = [ "bin" "dev" "lib" "out" "man" "info" ];

  nativeBuildInputs = [
    which pkgconfig perl autoreconfHook/*patches applied*/
  ] ++ stdenv.lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    # autogen needs a build autogen when cross-compiling
    buildPackages.buildPackages.autogen buildPackages.texinfo
  ];
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

  #doCheck = true; # not reliable

  postInstall = ''
    mkdir -p $dev/bin
    mv $bin/bin/autoopts-config $dev/bin

    for f in $lib/lib/autogen/tpl-config.tlib $out/share/autogen/tpl-config.tlib; do
      sed -e "s|$dev/include|/no-such-autogen-include-path|" -i $f
      sed -e "s|$bin/bin|/no-such-autogen-bin-path|" -i $f
      sed -e "s|$lib/lib|/no-such-autogen-lib-path|" -i $f
    done

  '' + stdenv.lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
    # remove /build/** from RPATHs
    for f in "$bin"/bin/*; do
      local nrp="$(patchelf --print-rpath "$f" | sed -E 's@(:|^)/build/[^:]*:@\1@g')"
      patchelf --set-rpath "$nrp" "$f"
    done
  '';

  meta = with stdenv.lib; {
    description = "Automated text and program generation tool";
    license = with licenses; [ gpl3Plus lgpl3Plus ];
    homepage = "https://www.gnu.org/software/autogen/";
    platforms = platforms.all;
    maintainers = [ ];
  };
}
