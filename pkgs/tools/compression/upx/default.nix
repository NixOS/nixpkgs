{ lib, stdenv, fetchurl, ucl, zlib, perl, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "upx";
  version = "3.96";
  src = fetchurl {
    url = "https://github.com/upx/upx/releases/download/v${version}/${pname}-${version}-src.tar.xz";
    sha256 = "051pk5jk8fcfg5mpgzj43z5p4cn7jy5jbyshyn78dwjqr7slsxs7";
  };

  buildInputs = [ ucl zlib perl ];

  patches = [
    (fetchpatch {
      url = "https://github.com/upx/upx/commit/13bc031163863cb3866aa6cdc018dff0697aa5d4.patch";
      sha256 = "sha256-7uazgx1lOgHh2J7yn3yb1q9lTJsv4BbexdGlWRiAG/M=";
      name = "CVE-2021-20285.patch";
    })
  ];

  preConfigure = ''
    export UPX_UCLDIR=${ucl}
  '';

  makeFlags = [
    "-C" "src"
    "CHECK_WHITESPACE=true"

    # Disable blanket -Werror. Triggers failues on minor gcc-11 warnings.
    "CXXFLAGS_WERROR="
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp src/upx.out $out/bin/upx
  '';

  meta = with lib; {
    homepage = "https://upx.github.io/";
    description = "The Ultimate Packer for eXecutables";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
  };
}
