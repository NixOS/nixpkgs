{ lib
, stdenv
, fetchurl
, fetchpatch
, openssl
}:

stdenv.mkDerivation rec {
  pname = "mailsend";
  version = "1.19";

  src = fetchurl {
    url = "https://github.com/muquit/mailsend/archive/${version}.tar.gz";
    sha256 = "sha256-Vl72vibFjvdQZcVRnq6N1VuuMUKShhlpayjSQrc0k/c=";
  };

  buildInputs = [
    openssl
  ];
  configureFlags = [
    "--with-openssl=${openssl.dev}"
  ];

  patches = [
    (fetchurl {
      url = "https://github.com/muquit/mailsend/commit/960df6d7a11eef90128dc2ae660866b27f0e4336.patch";
      sha256 = "0vz373zcfl19inflybfjwshcq06rvhx0i5g0f4b021cxfhyb1sm0";
    })
    # Pull fix pending upstream inclusion for parallel build failures:
    #   https://github.com/muquit/mailsend/pull/165
    (fetchpatch {
      name = "parallel-install.patch";
      url = "https://github.com/muquit/mailsend/commit/acd4ebedbce0e4af3c7b6632f905f73e642ca38c.patch";
      hash = "sha256-p8tNnkU6cMopuP63kVtRbD9aenhzL1EAXlvvFh4fucE=";
    })
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "CLI email sending tool";
    license = licenses.bsd3;
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.linux;
    homepage = "https://github.com/muquit/mailsend";
    downloadPage = "https://github.com/muquit/mailsend/releases";
  };
}
