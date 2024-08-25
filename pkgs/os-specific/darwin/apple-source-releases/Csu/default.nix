{ lib, appleDerivation', stdenv }:

appleDerivation' stdenv {

  prePatch = ''
    substituteInPlace Makefile \
      --replace-fail /usr/lib /lib \
      --replace-fail /usr/local/lib /lib \
      --replace-fail /usr/bin "" \
      --replace-fail /bin/ "" \
      --replace-fail "CC = " "#" \
      --replace-fail "SDK_DIR = " "SDK_DIR = . #" \

    # Mac OS didn't support rpaths back before 10.5, but we don't care about it.
    substituteInPlace Makefile \
      --replace-fail -mmacosx-version-min=10.4 -mmacosx-version-min=10.6 \
      --replace-fail -mmacosx-version-min=10.5 -mmacosx-version-min=10.6
  '';

  installFlags = [ "DSTROOT=$(out)" ];
  enableParallelInstalling = false; # cp: cannot create regular file '$out/lib/crt1.10.6.o'

  meta = with lib; {
    description = "Apple's common startup stubs for darwin";
    maintainers = with maintainers; [ copumpkin ];
    platforms   = platforms.darwin;
    license     = licenses.apple-psl20;
  };
}
