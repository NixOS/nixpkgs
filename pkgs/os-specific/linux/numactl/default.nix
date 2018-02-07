{ stdenv, fetchurl, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "numactl-2.0.10";

  src = fetchurl {
    url = "ftp://oss.sgi.com/www/projects/libnuma/download/${name}.tar.gz";
    sha256 = "0qfv2ks6d3gm0mw5sj4cbhsd7cbsb7qm58xvchl2wfzifkzcinnv";
  };

  nativeBuildInputs = [ autoreconfHook ];

  meta = with stdenv.lib; {
    description = "Library and tools for non-uniform memory access (NUMA) machines";
    homepage = http://oss.sgi.com/projects/libnuma/;
    license = licenses.gpl2;
    platforms = [ "i686-linux" "x86_64-linux" "aarch64-linux" ];
    maintainers = with maintainers; [ wkennington ];
  };
}
