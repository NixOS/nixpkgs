{ fetchurl, stdenv, guile, which, libffi }:

let version = "5.17"; in

  stdenv.mkDerivation {
    name = "autogen-${version}";

    src = fetchurl {
      url = "mirror://gnu/autogen/rel${version}/autogen-${version}.tar.gz";
      sha256 = "065mg9gfb605wxbsk3inf93528ygcjgg6j8ml51691f6ghj363ff";
    };

    buildInputs = [ guile which libffi ];

    patchPhase =
      '' for i in $(find -name \*.in)
         do
           sed -i "$i" -e's|/usr/bin/||g'
         done
      '';

    # The tests rely on being able to find `libopts.a'.
    configureFlags = "--enable-static";

    #doCheck = true; # 2 tests fail because of missing /dev/tty

    meta = {
      description = "Automated text and program generation tool";

      longDescription = ''
        AutoGen is a tool designed to simplify the creation and maintenance
        of programs that contain large amounts of repetitious text.  It is
        especially valuable in programs that have several blocks of text that
        must be kept synchronized.

        AutoGen can now accept XML files as definition input, in addition to
        CGI data (for producing dynamic HTML) and traditional AutoGen
        definitions.

        A common example where this would be useful is in creating and
        maintaining the code required for processing program options.
        Processing options requires multiple constructs to be maintained in
        parallel in different places in your program.  Options maintenance
        needs to be done countless times.  So, AutoGen comes with an add-on
        package named AutoOpts that simplifies the maintenance and
        documentation of program options.
      '';

      licenses = ["GPLv3+" "LGPLv3+" ];

      homepage = http://www.gnu.org/software/autogen/;

      maintainers = [ stdenv.lib.maintainers.ludo ];
    };
  }
