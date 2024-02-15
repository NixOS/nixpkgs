{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "socklog";
  version = "2.1.0";

  src = fetchurl {
    url = "http://smarden.org/socklog/socklog-${version}.tar.gz";
    sha256 = "0mdlmhiq2j2fip7c4l669ams85yc3c1s1d89am7dl170grw9m1ma";
  };

  sourceRoot = "admin/socklog-${version}";

  outputs = [ "out" "man" "doc" ];

  postPatch = ''
    # Fails to run as user without supplementary groups
    echo "int main() { return 0; }" >src/chkshsgr.c

    # Fixup implicit function declarations
    sed -i src/pathexec_run.c -e '1i#include <unistd.h>'
    sed -i src/prot.c -e '1i#include <unistd.h>' -e '2i#include <grp.h>'
    sed -i src/seek_set.c -e '1i#include <unistd.h>'
  '';

  configurePhase = ''
    echo "$NIX_CC/bin/cc $NIX_CFLAGS_COMPILE"   >src/conf-cc
    echo "$NIX_CC/bin/cc -s"                    >src/conf-ld
  '';

  buildPhase = "package/compile";

  installPhase = ''
    mkdir -p $out/bin
    mv command"/"* $out/bin

    for i in {1,8} ; do
      mkdir -p $man/share/man/man$i
      mv man"/"*.$i $man/share/man/man$i
    done

    mkdir -p $doc/share/doc/socklog/html
    mv doc/*.html $doc/share/doc/socklog/html/
  '';

  checkPhase = "package/check";

  doCheck = true;

  meta = with lib; {
    description = "System and kernel logging services";
    homepage = "http://smarden.org/socklog/";
    license = licenses.publicDomain;
    platforms = platforms.unix;
    maintainers = [ maintainers.joachifm ];
  };
}
