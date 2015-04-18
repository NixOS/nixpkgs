{ stdenv, fetchurl, p7zip, patchelf }:

assert stdenv.isLinux;

let
  bits    = if stdenv.system == "x86_64-linux" then "64" else "32";
  libPath = stdenv.lib.makeLibraryPath [ stdenv.cc.libc ];

  fixBin = x: ''
    patchelf --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath ${libPath} ${x}
  '';
in
stdenv.mkDerivation rec {
  name    = "hashcat-${version}";
  version = "0.47";

  src = fetchurl {
    url    = "http://hashcat.net/files/${name}.7z";
    sha256 = "0mc4lv4qfxabp794xfzgr63fhwk7lvbg12pry8a96lldp0jwp6i3";
  };

  buildInputs = [ p7zip patchelf ];

  unpackPhase = "7z x $src > /dev/null && cd ${name}";

  installPhase = ''
    mkdir -p $out/bin $out/libexec
    cp -R * $out/libexec

    echo -n "/" > $out/bin/eula.accepted
    ln -s $out/libexec/hashcat-cli${bits}.bin $out/bin/hashcat
    ln -s $out/libexec/hashcat-cliXOP.bin $out/bin/hashcat-xop
    ln -s $out/libexec/hashcat-cliAVX.bin $out/bin/hashcat-avx
  '';

  fixupPhase = ''
    ${fixBin "$out/libexec/hashcat-cli${bits}.bin"}
    ${fixBin "$out/libexec/hashcat-cliXOP.bin"}
    ${fixBin "$out/libexec/hashcat-cliAVX.bin"}
  '';

  meta = {
    description = "Fast password cracker";
    homepage    = "http://hashcat.net/hashcat/";
    license     = stdenv.lib.licenses.unfreeRedistributable;
    platforms   = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
