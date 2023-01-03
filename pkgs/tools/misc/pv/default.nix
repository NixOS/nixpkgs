{ lib
, stdenv
, fetchurl
, fetchpatch
}:

stdenv.mkDerivation rec {
  pname = "pv";
  version = "1.6.20";

  src = fetchurl {
    url = "https://www.ivarch.com/programs/sources/pv-${version}.tar.bz2";
    sha256 = "00y6zla8h653sn4axgqz7rr0x79vfwl62a7gn6lzn607zwg9acg8";
  };

  patches = [
    # Fix build on aarch64-darwin using patch from Homebrew
    (fetchpatch {
      url = "https://raw.githubusercontent.com/Homebrew/homebrew-core/0780f1df9fdbd8914ff50ac24eb0ec0d3561c1b7/Formula/pv.rb";
      sha256 = "001xayskfprri4s2gd3bqwajw6nz6nv0ggb0835par7q7bsd0dzr";
    })
  ];

  meta = {
    homepage = "http://www.ivarch.com/programs/pv";
    description = "Tool for monitoring the progress of data through a pipeline";
    license = lib.licenses.artistic2;
    maintainers = with lib.maintainers; [ ];
    platforms = with lib.platforms; all;
  };
}
