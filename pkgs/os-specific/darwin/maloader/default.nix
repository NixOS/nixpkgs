{ lib, stdenv, fetchFromGitHub, opencflite, clang, libcxx }:

stdenv.mkDerivation {
  pname = "maloader";
  version = "unstable-2014-02-25";

  src = fetchFromGitHub {
    owner = "shinh";
    repo = "maloader";
    rev = "5f220393e0b7b9ad0cf1aba0e89df2b42a1f0442";
    sha256 = "0dd1pn07x1y8pyn5wz8qcl1c1xwghyya4d060m3y9vx5dhv9xmzw";
  };

  postPatch = ''
    sed -i \
      -e '/if.*loadLibMac.*mypath/s|mypath|"'"$out/lib/"'"|' \
      -e 's|libCoreFoundation\.so|${opencflite}/lib/&|' \
      ld-mac.cc
  '';

  NIX_CFLAGS_COMPILE = "-I${lib.getDev libcxx}/include/c++/v1";
  buildInputs = [ clang libcxx ];
  buildFlags = [ "USE_LIBCXX=1" "release" ];

  installPhase = ''
    install -vD libmac.so "$out/lib/libmac.so"

    for bin in extract macho2elf ld-mac; do
      install -vD "$bin" "$out/bin/$bin"
    done
  '';

  meta = {
    description = "Mach-O loader for Linux";
    homepage = "https://github.com/shinh/maloader";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.linux;
    broken = true; # 2018-09-08, no succesful build since 2017-08-21
  };
}
