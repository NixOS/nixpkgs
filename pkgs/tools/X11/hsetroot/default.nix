{ stdenv, fetchurl, imlib2, libX11, xproto }:

let

  libPath = stdenv.lib.makeLibraryPath [
    imlib2
    libX11
  ];

in

stdenv.mkDerivation rec {
  name = "hsetroot-${version}";
  version = "1.0.2";

  src = fetchurl {
    url = "http://mirror.datapipe.net/gentoo/distfiles/hsetroot-${version}.tar.gz";
    sha256 = "d6712d330b31122c077bfc712ec4e213abe1fe71ab24b9150ae2774ca3154fd7";
  };

  buildInputs = [ imlib2 libX11 xproto ];

  dontPatchELF = true;

  postFixup = ''
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        --set-rpath ${libPath} \
        $out/bin/hsetroot
  '';

  meta = with stdenv.lib; {
    description = "Allows you to compose wallpapers ('root pixmaps') for X";
    homepage = http://thegraveyard.org/hsetroot.html;
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.henrytill ];
    platforms = platforms.unix;
  };
}
