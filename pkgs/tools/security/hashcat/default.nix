{ stdenv, fetchurl, gmp }:

assert stdenv.isLinux;

let
  bits = if stdenv.system == "x86_64-linux" then "64" else "32";
in
stdenv.mkDerivation rec {
  name    = "hashcat-${version}";
  version = "2.00";

  src = fetchurl {
    name = "${name}.tar.gz";
    url = "https://codeload.github.com/hashcat/hashcat/tar.gz/${version}";
    sha256 = "0i2l4i1jkdhj9bkvycgd2nf809kki3jp83y0vrd4iwsdbbbyc9b3";
  };

  buildInputs = [ gmp ];

  buildFlags = [ "posix${bits}" ]
    ++ stdenv.lib.optionals (bits == "64") [ "posixXOP" "posixAVX" ];

  # Upstream Makefile doesn't have 'install' target
  installPhase = ''
    mkdir -p $out/bin $out/libexec
    cp -R * $out/libexec

    ln -s $out/libexec/hashcat-cli${bits}.bin $out/bin/hashcat
    ln -s $out/libexec/hashcat-cliXOP.bin $out/bin/hashcat-xop
    ln -s $out/libexec/hashcat-cliAVX.bin $out/bin/hashcat-avx
  '';

  meta = {
    description = "Fast password cracker";
    homepage    = "http://hashcat.net/hashcat/";
    license     = stdenv.lib.licenses.mit;
    platforms   = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
