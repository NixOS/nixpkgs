{ lib, appleDerivation, xcbuild, ncurses, libutil, apple_sdk, fetchFromGitHub, runCommandNoCC }:

let
  OSXPrivateSDK = fetchFromGitHub {
    owner = "samdmarshall";
    repo = "OSXPrivateSDK";
    rev = "f4d52b60e86b496abfaffa119a7d299562d99783";
    sha256 = "sha256-EP9h3PngIw2uxAWXgh1/YHHDg28PyQ51FHPf7glCYC8=";
  };
  libsysmon = runCommandNoCC "sdk" {
    inherit OSXPrivateSDK;
  } ''
    install -Dm644 $OSXPrivateSDK/PrivateSDK10.10.sparse.sdk/usr/include/sysmon.h "$out"/include/sysmon.h
    mkdir -p "$out"/lib
    ln -s /usr/lib/libsysmon.dylib "$out"/lib/libsysmon.dylib
  '';
in

appleDerivation {
  # We can't just run the root build, because https://github.com/facebook/xcbuild/issues/264

  patchPhase = ''
    substituteInPlace adv_cmds.xcodeproj/project.pbxproj \
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
        install -D $f $out/bin/$(basename $f)
      fi
    done

    mkdir -p $out/System/Library/LaunchDaemons
    install fingerd/finger.plist $out/System/Library/LaunchDaemons

    # from variant_links.sh
    ln -s $out/bin/pkill $out/bin/pgrep
    # ln -s $out/share/man/man1/pkill.1 $out/share/man/man1/pgrep.1
  '';

  nativeBuildInputs = [ xcbuild ];
  buildInputs = [ ncurses libutil apple_sdk.libs.xpc libsysmon ];

  meta = {
    platforms = lib.platforms.darwin;
    maintainers = with lib.maintainers; [ matthewbauer ];
  };
}
