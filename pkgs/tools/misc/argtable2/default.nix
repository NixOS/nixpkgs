{ stdenv
, fetchurl
}:

stdenv.mkDerivation rec {
  name = "argtable-${version}";
  version = "2.13";

  src = fetchurl {
    url = http://prdownloads.sourceforge.net/argtable/argtable2-13.tar.gz;
    sha256 = "1gyxf4bh9jp5gb3l6g5qy90zzcf3vcpk0irgwbv1lc6mrskyhxwg";
  };

  meta = with stdenv.lib; {
    homepage = https://www.argtable.org/;
    description = "A Cross-Platform, Single-File, ANSI C Command-Line Parsing Library";
    license = licenses.bsd3;
    maintainers = with maintainers; [ rsoeldner ];
  };
}

