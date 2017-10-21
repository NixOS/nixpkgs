{ stdenv, fetchzip, libX11, libXScrnSaver, libXext, libXft, libXrender
, freetype, zlib, fontconfig
}:

let
  maybe64 = if stdenv.isx86_64 then "_64" else "";
  libPath = stdenv.lib.makeLibraryPath
    [ stdenv.cc.cc.lib libX11 libXScrnSaver libXext libXft libXrender freetype
      zlib fontconfig
    ];
in
stdenv.mkDerivation rec {
  version = "2.16";
  name = "sam-ba-${version}";

  src = fetchzip {
    url = "http://www.atmel.com/dyn/resources/prod_documents/sam-ba_${version}_linux.zip";
    sha256 = "18lsi4747900cazq3bf0a87n3pc7751j5papj9sxarjymcz9vks4";
  };

  # Pre-built binary package. Install everything to /opt/sam-ba to not mess up
  # the internal directory structure. Then create wrapper in /bin. Attemts to
  # use "patchelf --set-rpath" instead of setting LD_PRELOAD_PATH failed.
  installPhase = ''
    mkdir -p "$out/bin/" \
             "$out/opt/sam-ba/"
    cp -a . "$out/opt/sam-ba/"
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" "$out/opt/sam-ba/sam-ba${maybe64}"
    cat > "$out/bin/sam-ba" << EOF
    export LD_LIBRARY_PATH="${libPath}"
    exec "$out/opt/sam-ba/sam-ba${maybe64}"
    EOF
    chmod +x "$out/bin/sam-ba"
  '';

  # Do our own thing
  dontPatchELF = true;

  meta = with stdenv.lib; {
    description = "Programming tools for Atmel SAM3/7/9 ARM-based microcontrollers";
    longDescription = ''
      Atmel SAM-BA software provides an open set of tools for programming the
      Atmel SAM3, SAM7 and SAM9 ARM-based microcontrollers.
    '';
    homepage = http://www.at91.com/linux4sam/bin/view/Linux4SAM/SoftwareTools;
    # License in <source>/doc/readme.txt
    license = "BSD-like (partly binary-only)";  # according to Buildroot
    platforms = [ "x86_64-linux" ];  # patchelf fails on i686-linux
    maintainers = [ maintainers.bjornfor ];
  };
}
