{ stdenv, appleDerivation, xcbuild, ncurses, libutil }:

appleDerivation {
  # We can't just run the root build, because https://github.com/facebook/xcbuild/issues/264

  # pkill requires special private headers that are unavailable in
  # NixPkgs. These ones are needed:
  #  - xpc/xpxc.h
  #  - os/base_private.h
  #  - _simple.h
  # We disable it here for now. TODO: build pkill inside adv_cmds

  # We also disable locale here because of some issues with a missing
  # "lstdc++".
  patchPhase = ''
    substituteInPlace adv_cmds.xcodeproj/project.pbxproj \
      --replace "FD201DC214369B4200906237 /* pkill.c in Sources */," "" \
      --replace "FDF278D60FC6204E00D7A3C6 /* locale.cc in Sources */," "" \
      --replace '/usr/lib/libtermcap.dylib' 'libncurses.dylib'
  '';

  buildPhase = ''
    targets=$(xcodebuild -list \
                | awk '/Targets:/{p=1;print;next} p&&/^\s*$/{p=0};p' \
                | tail -n +2 | sed 's/^[ \t]*//' \
                | grep -v -e Desktop -e Embedded -e mklocale -e colldef)

    for i in $targets; do
      xcodebuild SYMROOT=$PWD/Products OBJROOT=$PWD/Intermediates -target $i
    done
  '';

  # temporary install phase until xcodebuild has "install" support
  installPhase = ''
    for f in Products/Release/*; do
      if [ -f $f ]; then
        install -D $file $out/bin/$(basename $f)
      fi
    done

    mkdir -p $out/System/Library/LaunchDaemons
    install fingerd/finger.plist $out/System/Library/LaunchDaemons

    # from variant_links.sh
    # ln -s $out/bin/pkill $out/bin/pgrep
    # ln -s $out/share/man/man1/pkill.1 $out/share/man/man1/pgrep.1
  '';

  nativeBuildInputs = [ xcbuild ];
  buildInputs = [ ncurses libutil ];

  meta = {
    platforms = stdenv.lib.platforms.darwin;
    maintainers = with stdenv.lib.maintainers; [ matthewbauer ];
  };
}
