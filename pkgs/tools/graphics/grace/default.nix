{ lib
, gccStdenv
, fetchurl
, coreutils
, motif
, fftw
, netcdf
, libpng
, libjpeg_original
, libX11
, libSM
, libXext
, libXmu
, libXp
, libXpm
, libXt
}:

stdenv.mkDerivation rec {
    pname = "grace";
    version = "5.1.25";
    src = fetchurl {
        url = "ftp://ftp.fu-berlin.de/unix/graphics/grace/src/grace5/grace-5.1.25.tar.gz";
        sha256 = "751ab9917ed0f6232073c193aba74046037e185d73b77bab0f5af3e3ff1da2ac";
    };

    buildInputs = [
      coreutils
      motif
      fftw
      netcdf
      libpng
      libjpeg_original
      libX11
      libSM
      libXext
      libXmu
      libXp
      libXpm
      libXt
    ];

    configurePhase = ''
        ./configure --enable-grace-home=$out \
                    --prefix=$out \
                    --disable-debug \
                    --with-bundled-t1lib=yes
    '';

    buildPhase = ''
        NIX_CFLAGS_COMPILE="-Wno-implicit-function-declaration -Wno-format-security $NIX_CFLAGS_COMPILE"

        make -j $(nproc)
        make install
    '';

    meta = with lib; {
      homepage = "https://plasma-gate.weizmann.ac.il/Grace/";
      description = "Grace is a WYSIWYG 2D plotting tool for the X Window System and M*tif. Grace is a descendant of ACE/gr, also known as Xmgr, and runs on practically any version of Unix-like OS.";
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.gpl2Only;
      # GNU GENERAL PUBLIC LICENSE

      # Version 2, June 1991

      # Copyright (C) 1989, 1991 Free Software Foundation, Inc.
      # 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA

      # Everyone is permitted to copy and distribute verbatim copies
      # of this license document, but changing it is not allowed.
    };
    maintainers = with maintainers; [ netforceexplorer ];
  };
}
