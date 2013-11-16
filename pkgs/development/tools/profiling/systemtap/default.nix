{ fetchurl, stdenv, linux, elfutils, latex2html, xmlto, docbook_xml_dtd_412
, libxml2, docbook_xsl, libxslt, texLive, texLiveExtra, ghostscript, pkgconfig
, gtkmm, libglademm, boost, perl, sqlite }:

stdenv.mkDerivation rec {
  name = "systemtap-1.2-${linux.version}";

  src = fetchurl {
    url = "http://sources.redhat.com/systemtap/ftp/releases/${name}.tar.gz";
    sha256 = "0kxgjr8p1pnncc0l4941gzx0jsyyqjzjqar2qkcjzp266ajn9qz6";
  };

  patches =
    stdenv.lib.optional (stdenv ? glibc) ./nixos-kernel-store-path.patch;

  postPatch =
    '' sed -i scripts/kernel-doc -e 's|/usr/bin/perl|${perl}/bin/perl|g'
    '';

  preConfigure =
    # XXX: This should really be handled by TeXLive's setup-hook.
    '' export TEXINPUTS="${latex2html}/texinputs:$TEXINPUTS"
       export TEXINPUTS="${texLiveExtra}/texmf-dist/tex/latex/preprint:$TEXINPUTS"
       echo "\$TEXINPUTS is \`$TEXINPUTS'"
    '';

  postConfigure =
    /* Work around this:

        StapParser.cxx:118:   instantiated from here
        /...-boost-1.42.0/include/boost/algorithm/string/compare.hpp:43: error: comparison between signed and unsigned integer expressions

     */
    '' sed -i "grapher/Makefile" -e's/-Werror//g'
    '';

  buildInputs =
    [ elfutils latex2html xmlto texLive texLiveExtra ghostscript
      pkgconfig gtkmm libglademm boost sqlite
      docbook_xml_dtd_412 libxml2
      docbook_xsl libxslt
    ];

  meta = {
    description = "SystemTap, tools to gather information about a running GNU/Linux system";

    longDescription =
      '' SystemTap provides free software (GPL) infrastructure to simplify
         the gathering of information about the running GNU/Linux system.
         This assists diagnosis of a performance or functional problem.
         SystemTap eliminates the need for the developer to go through the
         tedious and disruptive instrument, recompile, install, and reboot
         sequence that may be otherwise required to collect data.

         SystemTap provides a simple command line interface and scripting
         language for writing instrumentation for a live running kernel.  We
         are publishing samples, as well as enlarging the internal "tapset"
         script library to aid reuse and abstraction.

         Among other tracing/probing tools, SystemTap is the tool of choice
         for complex tasks that may require live analysis, programmable
         on-line response, and whole-system symbolic access.  SystemTap can
         also handle simple tracing jobs.
      '';

    homepage = http://sourceware.org/systemtap/;

    license = "GPLv2+";

    maintainers = [ ];
    platforms = stdenv.lib.platforms.linux;
    broken = true;
  };
}
