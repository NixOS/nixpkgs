{stdenv, fetchurl, traceDeps ? false}:

let
  traceLog = "/tmp/steam-trace-dependencies.log";
  version = "1.0.0.49";

in stdenv.mkDerivation rec {
  name = "steam-original-${version}";

  src = fetchurl {
    url = "http://repo.steampowered.com/steam/pool/steam/s/steam/steam_${version}.tar.gz";
    sha256 = "1c1gl5pwvb5gnnnqf5d9hpcjnfjjgmn4lgx8v0fbx1am5xf3p2gx";
  };

  makeFlags = [ "DESTDIR=$(out)" "PREFIX=" ];

  postInstall = ''
    rm $out/bin/steamdeps
    ${stdenv.lib.optionalString traceDeps ''
      cat > $out/bin/steamdeps <<EOF
      #!${stdenv.shell}
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
    license = licenses.unfreeRedistributable;
    maintainers = with maintainers; [ jagajaga ];
  };
}
