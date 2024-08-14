{
  stdenvNoCC,
  buildPackages,
  darwin-stubs,
}:

stdenvNoCC.mkDerivation {
  pname = "libSystem";
  inherit (darwin-stubs) version;

  nativeBuildInputs = [ buildPackages.darwin.rewrite-tbd ];

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

  buildCommand =
    ''
      mkdir -p $out/{include,lib/swift}
    ''
    # Copy each directory in ${darwin-stubs}/usr/include into $out/include
    + ''
      for dir in $(ls -d ${darwin-stubs}/usr/include/*/); do
        cp -dr $dir $out/include
      done
    ''
    # Copy each header and modulemap file in ${darwin-stubs}/usr/include into $out/include
    + ''
      cp -d \
        ${darwin-stubs}/usr/include/*.h \
        ${darwin-stubs}/usr/include/*.modulemap \
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
        ${darwin-stubs}/usr/lib/libSystem.* \
        ${darwin-stubs}/usr/lib/system \
        $out/lib

      # Extra libraries
      for name in c dbm dl info m mx poll proc pthread rpcsvc util gcc_s.1 resolv; do
        cp -d \
          ${darwin-stubs}/usr/lib/lib$name.tbd \
          ${darwin-stubs}/usr/lib/lib$name.*.tbd \
          $out/lib
      done

      for name in os Dispatch; do
        cp -dr \
          ${darwin-stubs}/usr/lib/swift/$name.swiftmodule \
          ${darwin-stubs}/usr/lib/swift/libswift$name.tbd \
          $out/lib/swift
      done

      for f in $csu; do
        from=${darwin-stubs}/usr/lib/$f
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
