{ stdenv, fetchgit, autoconf, libxcomp }:

let version = "3.5.0-2015-02-18"; in
stdenv.mkDerivation {
  name = "nxproxy-${version}";

  src = fetchgit {
    url = git://code.x2go.org/nx-libs.git;
    rev = "2b2a02f93f552a38de8f72a971fa3f3ff42b3298";
    sha256 = "11n7dv1cn9icjgyxmsbac115vmbaar47cmp8k76vd516f2x41dw9";
  };

  meta = with stdenv.lib; {
    description = "NX compression proxy";
    homepage = "http://code.x2go.org/gitweb?p=nx-libs.git;a=summary";
    license = with licenses; gpl2;
    platforms = with platforms; linux;
    maintainers = with maintainers; [ nckx ];
  };

  buildInputs = [ autoconf libxcomp ];

  preConfigure = ''
    cd nxproxy/
    autoconf
  '';

  installTargets = [ "install.bin" ];
}
