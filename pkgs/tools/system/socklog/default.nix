{ stdenv, fetchurl }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "socklog-${version}";
  version = "2.1.0";

  src = fetchurl {
    url = "http://smarden.org/socklog/socklog-${version}.tar.gz";
    sha256 = "0mdlmhiq2j2fip7c4l669ams85yc3c1s1d89am7dl170grw9m1ma";
  };

  sourceRoot = "admin/socklog-${version}";

  outputs = [ "out" "man" "doc" ];

  postPatch = ''
    sed -i src/TARGETS -e '/^chkshsgr/d'
  '';

  configurePhase = ''
    echo "$NIX_CC/bin/cc $NIX_CFLAGS_COMPILE"   >src/conf-cc
    echo "$NIX_CC/bin/cc -s"                    >src/conf-ld
  '';

  buildPhase = ''package/compile'';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mv command"/"* $out/bin

    for i in {1,8} ; do
      mkdir -p $man/share/man/man$i
      mv man"/"*.$i $man/share/man/man$i
    done

    mkdir -p $doc/share/doc/socklog/html
    mv doc/*.html $doc/share/doc/socklog/html/

    runHook postInstall
  '';

  checkPhase = ''package/check'';

  doCheck = true;

  meta = {
    description = "System and kernel logging services";
    homepage = http://smarden.org/socklog/;
    license = licenses.publicDomain;
    platforms = platforms.unix;
    maintainers = [ maintainers.joachifm ];
  };
}
