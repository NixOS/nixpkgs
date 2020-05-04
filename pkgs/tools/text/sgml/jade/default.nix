{ stdenv, fetchurl, gnum4 }:

stdenv.mkDerivation rec {
  name = "jade-${version}-${debpatch}";
  version = "1.2.1";
  debpatch = "47.3";

  src = fetchurl {
    url = "ftp://ftp.jclark.com/pub/jade/jade-${version}.tar.gz";
    sha256 = "84e2f8a2a87aab44f86a46b71405d4f919b219e4c73e03a83ab6c746a674b187";
  };

  patchsrc =  fetchurl {
    url = "http://ftp.debian.org/debian/pool/main/j/jade/jade_${version}-${debpatch}.diff.gz";
    sha256 = "8e94486898e3503308805f856a65ba5b499a6f21994151270aa743de48305464";
  };

  patches = [ patchsrc ];

  buildInputs = [ gnum4 ];

  NIX_CFLAGS_COMPILE = "-Wno-deprecated";

  preInstall = ''
    install -d -m755 "$out"/lib
  '';

  postInstall = ''
    mv "$out/bin/sx" "$out/bin/sgml2xml"
  '';

  meta = {
    description = "James Clark's DSSSL Engine";
    license = "custom";
    homepage = "http://www.jclark.com/jade/";
    platforms = with stdenv.lib.platforms; linux;
    maintainers = with stdenv.lib.maintainers; [ e-user ];
  };
}
