{ stdenv, fetchFromGitHub, autoconf, automake, libtool, pkgconfig, rdma-core
, opensm, perl, makeWrapper }:

stdenv.mkDerivation rec {
  name = "infiniband-diags-${version}";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "linux-rdma";
    repo = "infiniband-diags";
    rev = version;
    sha256 = "0dhidwscvv8rffgjl6ygrz7daf61wbgabzhb6v8wh5kccml90mxi";
  };

  nativeBuildInputs = [ autoconf automake libtool pkgconfig makeWrapper ];

  buildInputs = [ rdma-core opensm perl ];

  preConfigure = ''
    export CFLAGS="-I${opensm}/include/infiniband"
    ./autogen.sh
  '';

  configureFlags = [ "--with-perl-installdir=\${out}/${perl.libPrefix}" "--sbindir=\${out}/bin" ];

  postInstall = ''
    rmdir $out/var/run $out/var
  '';

  postFixup = ''
    for pls in $out/bin/{ibfindnodesusing.pl,ibidsverify.pl}; do
      echo "wrapping $pls"
      wrapProgram $pls --prefix PERL5LIB : "$out/${perl.libPrefix}"
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
