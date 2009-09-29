{ fetchurl, stdenv, guile, which }:

let version = "5.9.8"; in

  stdenv.mkDerivation {
    name = "autogen-${version}";

    src = fetchurl {
      url = "mirror://gnu/autogen/rel${version}/autogen-${version}.tar.bz2";
      sha256 = "0y3ygzhzzv7sa0ndvszpfqwcjg4hcb35bcp8qqsndmr6mh6v6cnn";
    };

    buildInputs = [ guile which ];

    # The tests rely on being able to find `libopts.a'.
    configureFlags = "--enable-static";

    doCheck = true;

    meta = {
      description = "GNU AutoGen, an automated text and program generation tool";

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

      license = "GPLv3+";

      homepage = http://www.gnu.org/software/autogen/;

      maintainers = [ stdenv.lib.maintainers.ludo ];
    };
  }
