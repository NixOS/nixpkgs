{
  stdenv, fetchzip
}:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "cndrvcups-doc";
  version = "2.71";

  src = fetchzip {
    url = "http://gdlp01.c-wss.com/gds/6/0100004596/05/linux-capt-drv-v271-uken.tar.gz";
    sha256 = "0agpai89vvqmjkkkk2gpmxmphmdjhiq159b96r9gybvd1c1l0dds";
  };

  postUnpack = "sourceRoot=\${sourceRoot}/Doc";

  # install directions based on arch PKGBUILD file
  # https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=capt-src

  installPhase = ''
    mkdir -p $out

    # Custom License
    install -dm755 $out/share/licenses
    install -Dm664 LICENSE-EN.txt $out/share/licenses/LICENSE-EN.txt

    # Guide & README
    install -Dm664 guide-capt-2.7xUK.tar.gz $out/share/doc/capt-src/guide-capt-2.7xUK.tar.gz
    install -Dm664 README-capt-2.71UK.txt $out/share/doc/capt-src/README-capt-2.71UK.txt
  '';

  meta = with stdenv.lib; {
    description = "Canon CAPT driver - documentation module";
  };
}
