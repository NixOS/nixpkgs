{ stdenv, fetchurl, unzip, autoreconfHook, libpo6, pkgconfig }:

stdenv.mkDerivation rec {
  name = "libe-${version}";
  version = "0.8.1";

  src = fetchurl {
    url = "https://github.com/rescrv/e/archive/releases/${version}.zip";
    sha256 = "18xm0hcnqdf0ipfn19jrgzqsxij5xjbbnihhzc57n4v7yfdca1w3";
  };

  buildInputs = [ unzip autoreconfHook libpo6 pkgconfig ];

  meta = with stdenv.lib; {
    description = "Library containing high-performance datastructures and utilities for C++";
    homepage = https://github.com/rescrv/e;
    license = licenses.bsd3;
  };
}
