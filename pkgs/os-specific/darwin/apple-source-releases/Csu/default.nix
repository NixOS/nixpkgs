{ lib
, Libsystem
, stdenvBootstrap
, appleDerivation'
}:

appleDerivation' stdenvBootstrap {
  prePatch = ''
    substituteInPlace Makefile \
      --replace /usr/lib /lib \
      --replace /usr/local/lib /lib \
      --replace /usr/bin "" \
      --replace /bin/ "" \
      --replace "CC = " "#" \
      --replace "SDK_DIR = " "SDK_DIR = . #"
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
