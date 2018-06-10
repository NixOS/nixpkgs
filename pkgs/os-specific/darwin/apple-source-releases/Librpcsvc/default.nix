{ stdenv, appleDerivation, developer_cmds }:

appleDerivation rec {
  buildInputs = [ developer_cmds ];

  installPhase = ''
    export DSTROOT=$out
    export SRCROOT=$PWD
    export OBJROOT=$PWD

    . ./xcodescripts/install_rpcsvc.sh

    mv $out/usr/* $out
    rmdir $out/usr/
  '';

  meta = with stdenv.lib; {
    maintainers = with maintainers; [ matthewbauer ];
    platforms   = platforms.darwin;
    license     = licenses.apsl20;
  };
}
