{ stdenv, fetchurl, nukeReferences }:
let
  pname = "open-iscsi-2.0-873";
in stdenv.mkDerivation {
  name = pname;
  outputs = [ "out" "iscsistart" ];

  buildInputs = [ nukeReferences ];
  
  src = fetchurl {
    urls = [
      "http://www.open-iscsi.org/bits/${pname}.tar.gz"
      "http://pkgs.fedoraproject.org/repo/pkgs/iscsi-initiator-utils/${pname}.tar.gz/8b8316d7c9469149a6cc6234478347f7/${pname}.tar.gz"
    ];
    sha256 = "1nbwmj48xzy45h52917jbvyqpsfg9zm49nm8941mc5x4gpwz5nbx";
  };
  
  DESTDIR = "$(out)";
  
  preConfigure = ''
    sed -i 's|/usr/|/|' Makefile
  '';
  
  postInstall = ''
    mkdir -pv $iscsistart/bin/
    cp -v usr/iscsistart $iscsistart/bin/
    nuke-refs $iscsistart/bin/iscsistart
  '';

  meta = with stdenv.lib; {
    description = "A high performance, transport independent, multi-platform implementation of RFC3720";
    license = licenses.gpl2Plus;
    homepage = http://www.open-iscsi.org;
    platforms = platforms.linux;
  };
}
