{ stdenv
}:

stdenv.mkDerivation rec
{
    name = "ibtool";

    # Copying local files.
    preferLocalBuild = true;

    __propagatedImpureHostDeps = [ "/usr/lib/libxcselect.dylib"
                                   "/usr/lib/libSystem.B.dylib"
                                 ];

    phases = [ "installPhase"
               "fixupPhase"
             ];

    installPhase = ''
        mkdir -p $out/bin
        ln -s -L /usr/bin/ibtool $out/bin/ibtool
    '';

    meta = with stdenv.lib;
    {
        description = "ibtool xib compiler";
        platforms = platforms.darwin;
    };
}
