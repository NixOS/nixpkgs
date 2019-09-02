{ stdenv, fetchFromGitHub, fetchpatch, cmake, fuse, zlib, bzip2, openssl, libxml2, icu } :

stdenv.mkDerivation rec {
  pname = "darling-dmg";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "darlinghq";
    repo = "darling-dmg";
    rev = "v${version}";
    sha256 = "0x285p16zfnp0p6injw1frc8krif748sfgxhdd7gb75kz0dfbkrk";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/darlinghq/darling-dmg/commit/cbb0092264b5c5cf3e92d6c2de23f02d859ebf44.patch";
    sha256 = "05fhgn5c09f1rva6bvbq16nhlkblrhscbf69k04ajwdh7y98sw39";
     })
  ];

  buildInputs = [ cmake fuse openssl zlib bzip2 libxml2 icu ];

  # compat with icu61+ https://github.com/unicode-org/icu/blob/release-64-2/icu4c/readme.html#L554
  CXXFLAGS = [ "-DU_USING_ICU_NAMESPACE=1" ];

  meta = {
    homepage = http://www.darlinghq.org/;
    description = "Darling lets you open macOS dmgs on Linux";
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.gpl3;
  };
}
