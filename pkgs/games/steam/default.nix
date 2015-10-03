{stdenv, fetchurl, traceDeps ? false}:

stdenv.mkDerivation rec {
  name = "${program}-original-${version}";
  program = "steam";
  version = "1.0.0.49";

  src = fetchurl {
    url = "http://repo.steampowered.com/steam/pool/steam/s/steam/${program}_${version}.tar.gz";
    sha256 = "1c1gl5pwvb5gnnnqf5d9hpcjnfjjgmn4lgx8v0fbx1am5xf3p2gx";
  };

  traceLog = "/tmp/steam-trace-dependencies.log";

  installPhase = ''
    make DESTDIR=$out install
    mv $out/usr/* $out #*/
    rmdir $out/usr

    rm $out/bin/steamdeps
    ${stdenv.lib.optionalString traceDeps ''
      cat > $out/bin/steamdeps <<EOF
      #! /bin/bash
      echo \$1 >> ${traceLog}
      cat \$1 >> ${traceLog}
      echo >> ${traceLog}
      EOF
      chmod +x $out/bin/steamdeps
    ''}
  '';

  meta = with stdenv.lib; {
    description = "A digital distribution platform";
    homepage = http://store.steampowered.com/;
    license = licenses.unfree;
    maintainers = with maintainers; [ jagajaga ];
  };
}
