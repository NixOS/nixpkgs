{ stdenv, fetchurl, unzip, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "libpo6-${version}";
  version = "0.5.2";

  src = fetchurl {
    url = "https://github.com/rescrv/po6/archive/releases/${version}.zip";
    sha256 = "17grzkh6aw1f68qvkhivbb6vwbm6jd41ysbfn88pypf5lczxrxly";
  };

  buildInputs = [ unzip autoreconfHook ];

  meta = with stdenv.lib; {
    description = "POSIX wrappers for C++";
    homepage = https://github.com/rescrv/po6;
    license = licenses.bsd3;
  };
}
