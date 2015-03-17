{ stdenv, fetchurl, autoconf, libxcomp }:

let version = "3.5.0.30"; in
stdenv.mkDerivation {
  name = "nxproxy-${version}";

  src = fetchurl {
    url = "http://code.x2go.org/releases/source/nx-libs/nx-libs-${version}-full.tar.gz";
    sha256 = "0npwlfv9p5fwnf30fpkfw08mq11pgbvp3d2zgnhh8ykf3yj8dgv0";
  };

  meta = with stdenv.lib; {
    description = "NX compression proxy";
    homepage = "http://wiki.x2go.org/doku.php/wiki:libs:nx-libs";
    license = with licenses; gpl2;
    platforms = with platforms; linux;
    maintainers = with maintainers; [ nckx ];
  };

  buildInputs = [ autoconf libxcomp ];

  preConfigure = ''
    cd nxproxy/
    autoconf
  '';

  makeFlags = [ "exec_prefix=$(out)" ];
}
