{ stdenv, fetchurl }:

stdenv.mkDerivation rec {

  name = "f-prot-${version}";
  version = "6.2.1";

  src = fetchurl {
    url = http://files.f-prot.com/files/unix-trial/fp-Linux.x86.32-ws.tar.gz;
    sha256 = "0qlsrkanf0inplwv1i6hqbimdg91syf5ggd1vahsm9lhivmnr0v5";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp fpscan $out/bin

    mkdir -p $out/opt/f-prot
    cp fpupdate $out/opt/f-prot
    cp product.data.default $out/opt/f-prot/product.data
    cp license.key $out/opt/f-prot/
    cp f-prot.conf.default $out/opt/f-prot/f-prot.conf
    ln -s $out/opt/f-prot/fpupdate $out/bin/fpupdate

    patchelf --interpreter "$(cat $NIX_GCC/nix-support/dynamic-linker)" $out/opt/f-prot/fpupdate

    mkdir -p $out/share/man/
    mkdir -p $out/share/man/man1
    cp doc/man/fpscan.1 $out/share/man/man1
    mkdir -p $out/share/man/man5
    cp doc/man/f-prot.conf.5 $out/share/man/man5
    mkdir -p $out/share/man/man8
    cp doc/man/fpupdate.8 $out/share/man/man8
  '';

  meta = with stdenv.lib; {
    homepage = http://www.f-prot.com;
    description = "A popular proprietary antivirus program";
    license = licenses.unfree;
    maintainers = [ maintainers.phreedom ];
    platforms = platforms.linux;
  };
}