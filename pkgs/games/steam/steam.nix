{stdenv, fetchurl, traceDeps ? false}:

let
  traceLog = "/tmp/steam-trace-dependencies.log";
  version = "1.0.0.51";

in stdenv.mkDerivation rec {
  name = "steam-original-${version}";

  src = fetchurl {
    url = "http://repo.steampowered.com/steam/pool/steam/s/steam/steam_${version}.tar.gz";
    sha256 = "1ghrfznm9rckm8v87zvh7hx820r5pp7sq575wxwq0fncbyq6sxmz";
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
