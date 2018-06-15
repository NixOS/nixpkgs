{ stdenv, fetchFromGitHub, autoconf, automake, libtool, pkgconfig, rdma-core,
  glib, opensm, perl, makeWrapper }:

stdenv.mkDerivation rec {
  name = "infiniband-diags-${version}";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "linux-rdma";
    repo = "infiniband-diags";
    rev = version;
    sha256 = "06x8yy3ly1vzraznc9r8pfsal9mjavxzhgrla3q2493j5jz0sx76";
  };

  nativeBuildInputs = [ autoconf automake libtool pkgconfig makeWrapper ];

  buildInputs = [ rdma-core glib opensm perl ];

  preConfigure = ''
    export CFLAGS="-I${opensm}/include/infiniband"
    ./autogen.sh
  '';

  configureFlags = "--with-perl-installdir=\${out}/lib/perl5/site_perl --sbindir=\${out}/bin";

  postInstall = ''
    rmdir $out/var/run $out/var
  '';

  postFixup = ''
    for pls in $out/bin/{ibfindnodesusing.pl,ibidsverify.pl}; do
      echo "wrapping $pls"
      wrapProgram $pls --prefix PERL5LIB : "$out/lib/perl5/site_perl"
    done
  '';

  meta = with stdenv.lib; {
    description = "Utilities designed to help configure, debug, and maintain infiniband fabrics";
    homepage = http://linux-rdma.org/;
    license =  licenses.bsd2; # Or GPL 2
    maintainers = [ maintainers.aij ];
    platforms = [ "x86_64-linux" ];
  };
}
