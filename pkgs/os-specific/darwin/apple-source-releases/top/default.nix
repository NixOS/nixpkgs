{xcbuildHook, appleDerivation, apple_sdk, ncurses, libutil-new, lib}:

appleDerivation {
  nativeBuildInputs = [ xcbuildHook ];
  buildInputs = [ apple_sdk.frameworks.IOKit ncurses libutil-new ];
  NIX_LDFLAGS = "-lutil";
  installPhase = ''
    install -D Products/Release/libtop.a $out/lib/libtop.a
    install -D Products/Release/libtop.h $out/include/libtop.h
    install -D Products/Release/top $out/bin/top
  '';
  meta = {
    platforms = lib.platforms.darwin;
    maintainers = with lib.maintainers; [ matthewbauer ];
  };
}
