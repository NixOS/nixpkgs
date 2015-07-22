{ stdenv, fetchurl, zlib }:

let version = "2.0.10"; in
stdenv.mkDerivation rec {
  name = "kexec-tools-${version}";

  src = fetchurl {
    url = "http://horms.net/projects/kexec/kexec-tools/${name}.tar.xz";
    sha256 = "18x134nj37j1rshn5hxbyhdcv9kk5sfshs72alkip1icf54l2gp2";
  };

  buildInputs = [ zlib ];

  meta = with stdenv.lib; {
    inherit version;
    homepage = http://horms.net/projects/kexec/kexec-tools;
    description = "Tools related to the kexec Linux feature";
    platforms = with platforms; linux;
    maintainers = with maintainers; [ nckx ];
  };
}
