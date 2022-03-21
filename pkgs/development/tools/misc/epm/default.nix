{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, rpm
}:

stdenv.mkDerivation rec {
  pname = "epm";
  version = "5.0.0";

  src = fetchFromGitHub {
    owner = "jimjag";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-o4B5lWBeve+U70FDgF1DrtNrXxaEY4etkPpwbqF7fmc=";
  };

  patches = [
    # Makefile fix: INSTALL command
    (fetchpatch {
      url = "https://github.com/jimjag/epm/commit/dc5fcd6fa6e3a74baa28be060769a2b47f9368e7.patch";
      sha256 = "1gfyz493w0larin841xx3xalb7m3sp1r2vv1xki6rz35ybrnb96c";
    })
    # Makefile fix: man pages filenames and docdir target
    (fetchpatch {
      url = "https://github.com/jimjag/epm/commit/96bb48d4d7b463a09d5a25debfb51c88dcd7398c.patch";
      sha256 = "11aws0qac6vyy3w5z39vkjy4symmfzxfq9qgbgkk74fvx9vax42a";
    })
  ];

  buildInputs = [ rpm ];

  meta = with lib; {
    description = "The ESP Package Manager generates distribution archives for a variety of platforms";
    homepage = "https://jimjag.github.io/epm/";
    license = licenses.asl20;
    maintainers = with maintainers; [ pSub ];
    platforms = platforms.unix;
  };
}
