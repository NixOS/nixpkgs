{ lib, appleDerivation, developer_cmds }:

appleDerivation {
  buildInputs = [ developer_cmds ];

  installPhase = ''
    export DSTROOT=$out
    export SRCROOT=$PWD
    export OBJROOT=$PWD

    . ./xcodescripts/install_rpcsvc.sh

    mv $out/usr/* $out
    rmdir $out/usr/
  '';

  meta = with lib; {
    maintainers = with maintainers; [ matthewbauer ];
    platforms   = platforms.darwin;
    license     = licenses.apple-psl20;
  };
}
