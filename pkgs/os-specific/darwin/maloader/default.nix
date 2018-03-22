{ stdenv, fetchFromGitHub, opencflite, libuuid, zlib }:

stdenv.mkDerivation {
  name = "maloader-2017-05-27";

  src = fetchFromGitHub {
    owner = "shinh";
    repo = "maloader";
    rev = "bdff0a61952c13d88a474986cabce2304e6b8e61";
    sha256 = "0axvm9h2n0q81z811njxmjbx4j8q971aik2ip74fdq8b61g95hqz";
  };

  postPatch = ''
    sed -i \
      -e '/if.*loadLibMac.*mypath/s|mypath|"'"$out/lib/"'"|' \
      -e 's|libCoreFoundation\.so|${opencflite}/lib/&|' \
      ld-mac.cc
  '';

  buildInputs = [ libuuid zlib ];

  buildFlags = [ "USE_LIBCXX=1" "release" ];

  NIX_CFLAGS_COMPILE = "-Wno-error=unused-command-line-argument";

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
