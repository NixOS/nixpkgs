{
  lib,
  stdenv,
  fetchurl,
  gnum4,
}:

stdenv.mkDerivation rec {
  pname = "jade";
  version = "1.2.1";
  debpatch = "47.3";

  src = fetchurl {
    url = "ftp://ftp.jclark.com/pub/jade/jade-${version}.tar.gz";
    sha256 = "84e2f8a2a87aab44f86a46b71405d4f919b219e4c73e03a83ab6c746a674b187";
  };

  patchsrc = fetchurl {
    url = "mirror://debian/pool/main/j/jade/jade_${version}-${debpatch}.diff.gz";
    sha256 = "8e94486898e3503308805f856a65ba5b499a6f21994151270aa743de48305464";
  };

  patches = [ patchsrc ];

  buildInputs = [ gnum4 ];

  env.NIX_CFLAGS_COMPILE = "-Wno-deprecated";

  # Makefile is missing intra-library depends, fails build as:
  # ld: cannot find -lsp
  # ld: cannot find -lspgrove
  enableParallelBuilding = false;

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
    platforms = with lib.platforms; linux;
    maintainers = with lib.maintainers; [ ];
  };
}
