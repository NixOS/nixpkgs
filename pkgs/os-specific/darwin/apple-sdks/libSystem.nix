{
  buildPackages,
  MacOSX-SDK,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation {
  inherit (MacOSX-SDK) version;
  pname = "libSystem";

  dontBuild = true;
  dontUnpack = true;

  nativeBuildInputs = [buildPackages.darwin.rewrite-tbd];

  csu = [
    "bundle1.o"
    "crt0.o"
    "crt1.10.5.o"
    "crt1.10.6.o"
    "crt1.o"
    "dylib1.10.5.o"
    "dylib1.o"
    "gcrt1.o"
    "lazydylib1.o"
  ];

  installPhase =
    ''
      mkdir -p $out/{include,lib/swift}
    ''
    # Copy each directory in ${MacOSX-SDK}/usr/include into $out/include
    + ''
      for dir in $(ls -d ${MacOSX-SDK}/usr/include/*/); do
        cp -dr $dir $out/include
      done
    ''
    # Copy each header and modulemap file in ${MacOSX-SDK}/usr/include into $out/include
    + ''
      cp -d \
        ${MacOSX-SDK}/usr/include/*.h \
        ${MacOSX-SDK}/usr/include/*.modulemap \
        $out/include
    ''
    # Remove curses.h, ncurses.h, ncurses_dll.h, and unctrl.h which conflict with ncurses.
    # Then, remove the module map for ncurses.
    # NOTE: The sed expression expects the module map to use consistent indentation across
    #   releases. If this changes, the sed expression will need to be updated.
    #
    #   For example, right now we assume that there is one leading space before the
    #   "explicit" keyword and that the closing brace is on its own line (also with one
    #   leading space).
    + ''
      rm $out/include/{curses,ncurses,ncurses_dll,unctrl}.h
      sed -i -e '/^ explicit module ncurses {/,/^ }$/d' $out/include/module.modulemap
    ''
    + ''
      rm $out/include/tk*.h $out/include/tcl*.h

      cp -dr \
        ${MacOSX-SDK}/usr/lib/libSystem.* \
        ${MacOSX-SDK}/usr/lib/system \
        $out/lib

      # Extra libraries
      for name in c dbm dl info m mx poll proc pthread rpcsvc util gcc_s.1 resolv; do
        cp -d \
          ${MacOSX-SDK}/usr/lib/lib$name.tbd \
          ${MacOSX-SDK}/usr/lib/lib$name.*.tbd \
          $out/lib
      done

      for name in os Dispatch; do
        cp -dr \
          ${MacOSX-SDK}/usr/lib/swift/$name.swiftmodule \
          ${MacOSX-SDK}/usr/lib/swift/libswift$name.tbd \
          $out/lib/swift
      done

      for f in $csu; do
        from=${MacOSX-SDK}/usr/lib/$f
        if [ -e "$from" ]; then
          cp -d $from $out/lib
        else
          echo "Csu file '$from' doesn't exist: skipping"
        fi
      done

      chmod u+w -R $out/lib
      find $out -name '*.tbd' -type f | while read tbd; do
        rewrite-tbd \
          -c /usr/lib/libsystem.dylib:$out/lib/libsystem.dylib \
          -p /usr/lib/system/:$out/lib/system/ \
          -p /usr/lib/swift/:$out/lib/swift/ \
          -r ${builtins.storeDir} \
          "$tbd"
      done
    '';
}
