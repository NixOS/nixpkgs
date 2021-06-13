{ stdenv, fetchurl, cups, ghostscript }:

stdenv.mkDerivation rec {
  pname = "cups-pdf";
  version = "3.0.1";

  src = fetchurl {
    url = "https://www.cups-pdf.de/src/${pname}_${version}.tar.gz";
    sha256 = "0ccmm9crrm07nqzn4aikbys2bflkgzc044j1bvz6j53zzznnk1kk";
  };

  buildInputs = [ cups ghostscript ];

  preBuild = ''
    sed '/#define CP_CONFIG_PATH/s@/etc/cups@/etc/cups-pdf@' -i src/cups-pdf.h
    substituteInPlace src/cups-pdf.h --replace "/usr/bin/gs" "${ghostscript}/bin/gs"
    substituteInPlace extra/cups-pdf.conf --replace "/usr/bin/gs" "${ghostscript}/bin/gs"
  '';

  buildPhase = ''
    runHook preBuild

    pushd src >/dev/null
    $CC -s ${pname}.c -o ${pname} -lcups
    popd >/dev/null

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    # From README: CUPS-PDF requires root privileges since it has to
    # modify file ownerships. In order to ensure CUPS-PDF is running
    # with the required root privileges you have to make 'root' the
    # owner of the cups-pdf backend and set the file permissions of
    # the backend to 0700 (root only). So we use
    # `security.wrappers.cups-pdf' and install provided backend as
    # source for it:
    install -D -t $out/lib/cups/backend.orig src/cups-pdf

    # Install PPDs:
    install -D -m0644 -t $out/share/cups/model/CUPS-PDF extra/*.ppd

    # Install docs:
    install -D -m0644 -t $out/share/doc {README,ChangeLog}
    install -D -m0644 -t $out/share/doc extra/cups-pdf.conf

    # Install the real backend:
    mkdir -p $out/lib/cups/backend
    ln -s /run/wrappers/bin/cups-pdf $out/lib/cups/backend/cups-pdf

    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description = "A virtual PDF printer for CUPS";
    homepage = "https://www.cups-pdf.de";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ caadar ];
    platforms = platforms.unix;
  };

}
