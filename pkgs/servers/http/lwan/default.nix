{ stdenv, fetchFromGitHub, pkgconfig, zlib, cmake, jemalloc }:

stdenv.mkDerivation rec {
  pname = "lwan";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "lpereira";
    repo = pname;
    rev = "v${version}";
    sha256 = "1mckryzb06smky0bx2bkqwqzpnq4pb8vlgmmwsvqmwi4mmw9wmi1";
  };

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [ jemalloc zlib ];

  meta = with stdenv.lib; {
    description = "Lightweight high-performance multi-threaded web server";
    longDescription = "A lightweight and speedy web server with a low memory
      footprint (~500KiB for 10k idle connections), with minimal system calls and
      memory allocation.  Lwan contains a hand-crafted HTTP request parser. Files are
      served using the most efficient way according to their size: no copies between
      kernel and userland for files larger than 16KiB.  Smaller files are sent using
      vectored I/O of memory-mapped buffers. Header overhead is considered before
      compressing small files.  Features include: mustache templating engine and IPv6
      support.
    ";
    homepage = "https://lwan.ws/";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ leenaars ];
  };
}
