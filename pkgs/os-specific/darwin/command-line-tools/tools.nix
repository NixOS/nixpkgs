{ stdenv, cpio, gzip, cmdline_packages }:

stdenv.mkDerivation {
  name = "osx-command-line-sdk-10.9";
  src  = cmdline_packages.cltools;

  phases = [ "unpackPhase" "installPhase" "fixupPhase" ];

  unpackPhase = ''
    cat $src/Payload | ${gzip}/bin/gzip -d | ${cpio}/bin/cpio -idm
  '';

  installPhase = ''
    mkdir -p $out
    cp -r Library/Developer/CommandLineTools/Library $out
    cp -r Library/Developer/CommandLineTools/usr/* $out
  '';

  meta = with stdenv.lib; {
    description = "Apple command-line developer tools";
    maintainers = with maintainers; [ copumpkin ];
    platforms   = platforms.darwin;
    license     = licenses.unfree;
  };
}
