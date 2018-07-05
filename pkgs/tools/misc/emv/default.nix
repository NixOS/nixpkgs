{ wrapCommand, lib, bash, fetchurl }:

let
  src = fetchurl {
    url = "http://www.i0i0.de/toolchest/emv";
    sha256 = "7e0e12afa45ef5ed8025e5f2c6deea0ff5f512644a721f7b1b95b63406a8f7ce";
  };
in wrapCommand "emv" {
  version = "1.95";
  executable = "${bash}/bin/bash";
  makeWrapperArgs = [ "--add-flags ${src}" ];
  meta = with lib; {
    homepage = http://www.i0i0.de/toolchest/emv;
    description = "Editor Move: Rename files with your favourite text editor";
    license = licenses.publicDomain;
    platforms = platforms.unix;
  };
}
