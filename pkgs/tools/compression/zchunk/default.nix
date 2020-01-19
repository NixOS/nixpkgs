{ stdenv, fetchFromGitHub, fetchpatch, meson, ninja, pkgconfig, curl, openssl, zstd, argp-standalone }:

stdenv.mkDerivation rec {
  pname = "zchunk";
  version = "1.1.5";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "13sqjslk634mkklnmzdlzk9l9rc6g6migig5rln3irdnjrxvjf69";
  };

  patches = [
    (fetchpatch {
      url = "https://raw.githubusercontent.com/void-linux/void-packages/5aa57003367c31a6ced50a0fa144a2a3bd71b045/srcpkgs/zchunk/patches/001-musl.patch";
      sha256 = "0dzchagcw67c02ns796savyadbhmc484wfr6kayql1w7b0i25mdz";
      extraPrefix = "";
    })
    (fetchpatch {
      url = "https://raw.githubusercontent.com/void-linux/void-packages/5aa57003367c31a6ced50a0fa144a2a3bd71b045/srcpkgs/zchunk/patches/002-musl.patch";
      sha256 = "0f62q0cc144k9jd9lnf0b185szcl153gh9qg6jfximb46x99hvf4";
      extraPrefix = "";
    })
  ];

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ meson ninja pkgconfig ];
  buildInputs =  [ curl openssl zstd ]
    ++ stdenv.lib.optional stdenv.hostPlatform.isMusl argp-standalone;
  NIX_LDFLAGS = stdenv.lib.optionalString stdenv.hostPlatform.isMusl "-largp";

  doCheck = true;

  meta = with stdenv.lib; {
    description = "Easy-to-delta, compressed file format";
    license = licenses.bsd2;
    homepage = "https://github.com/zchunk/zchunk";
    maintainers = with maintainers; [ dtzWill ];
  };
}
