{ lib
, stdenv
, fetchsvn
, pkgconfig
, libjpeg
, libpng
, flex
, zlib
, perl
, libxml2
, makeWrapper
, libtiff
, enableX11 ? false
, libX11
}:

stdenv.mkDerivation {
  # Determine version and revision from:
  # https://sourceforge.net/p/netpbm/code/HEAD/log/?path=/advanced
  name = "netpbm-10.89.1";

  outputs = [ "bin" "out" "dev" ];

  src = fetchsvn {
    url = "https://svn.code.sf.net/p/netpbm/code/advanced";
    rev = "3735";
    sha256 = "hRepEUBlf83p77Amjze+Qz7XTHhCuPdV01K/UabR89Q=";
  };

  postPatch = ''
    # Install libnetpbm.so symlink to correct destination
    substituteInPlace lib/Makefile \
      --replace '/sharedlink' '/lib'
  '';

  nativeBuildInputs = [
    pkgconfig
    flex
    makeWrapper
  ];

  buildInputs = [
    zlib
    perl
    libpng
    libjpeg
    libxml2
    libtiff
  ] ++ lib.optional enableX11 libX11;

  configurePhase = ''
    runHook preConfigure

    cp config.mk.in config.mk

    # Disable building static library
    echo "STATICLIB_TOO = N" >> config.mk

    # Use libraries from Nixpkgs
    echo "TIFFLIB = libtiff.so" >> config.mk
    echo "TIFFLIB_NEEDS_JPEG = N" >> config.mk
    echo "TIFFLIB_NEEDS_Z = N" >> config.mk
    echo "JPEGLIB = libjpeg.so" >> config.mk

    # Fix path to rgb.txt
    echo "RGB_DB_PATH = $out/share/netpbm/misc/rgb.txt" >> config.mk
  '' + stdenv.lib.optionalString stdenv.isDarwin ''
    echo "LDSHLIB=-dynamiclib -install_name $out/lib/libnetpbm.\$(MAJ).dylib" >> config.mk
    echo "NETPBMLIBTYPE = dylib" >> config.mk
    echo "NETPBMLIBSUFFIX = dylib" >> config.mk

    runHook postConfigure
  '';

  enableParallelBuilding = true;

  installPhase = ''
    runHook preInstall

    make package pkgdir=$out

    rm -rf $out/*_template $out/{pkginfo,README,VERSION} $out/man/web

    mkdir -p $out/share/netpbm
    mv $out/misc $out/share/netpbm/

    moveToOutput bin "''${!outputBin}"

    # wrap any scripts that expect other programs in the package to be in their PATH
    for prog in ppmquant; do
        wrapProgram "''${!outputBin}/bin/$prog" --prefix PATH : "''${!outputBin}/bin"
    done

    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    homepage = "http://netpbm.sourceforge.net/";
    description = "Toolkit for manipulation of graphic images";
    license = lib.licenses.free; # http://netpbm.svn.code.sourceforge.net/p/netpbm/code/trunk/doc/copyright_summary
    platforms = with stdenv.lib.platforms; linux ++ darwin;
  };
}
