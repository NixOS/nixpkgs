{ stdenv, fetchgit, opencflite, clang, libcxx }:

stdenv.mkDerivation {
  name = "maloader-0git";

  src = fetchgit {
    url = "git://github.com/shinh/maloader.git";
    rev = "5f220393e0b7b9ad0cf1aba0e89df2b42a1f0442";
    sha256 = "07j9b7n0grrbxxyn2h8pnk6pa8b370wq5z5zwbds8dlhi7q37rhn";
  };

  postPatch = ''
    sed -i \
      -e '/if.*loadLibMac.*mypath/s|mypath|"'"$out/lib/"'"|' \
      -e 's|libCoreFoundation\.so|${opencflite}/lib/&|' \
      ld-mac.cc
  '';

  NIX_CFLAGS_COMPILE = "-I${libcxx}/include/c++/v1";
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
    homepage = https://github.com/shinh/maloader;
    license = stdenv.lib.licenses.bsd2;
  };
}
