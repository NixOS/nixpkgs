{stdenv, fetchurl, runtimeShell, traceDeps ? false}:

let
  traceLog = "/tmp/steam-trace-dependencies.log";
  version = "1.0.0.70";

in stdenv.mkDerivation {
  pname = "steam-original";
  inherit version;

  src = fetchurl {
    url = "https://repo.steampowered.com/steam/archive/stable/steam_${version}.tar.gz";
    sha256 = "sha256-n/iKV3jHsA77GPMk1M0MKC1fQ42tEgG8Ppgi4/9qLf8=";
  };

  makeFlags = [ "DESTDIR=$(out)" "PREFIX=" ];

  postInstall = ''
    rm $out/bin/steamdeps
    ${stdenv.lib.optionalString traceDeps ''
      cat > $out/bin/steamdeps <<EOF
      #!${runtimeShell}
      echo \$1 >> ${traceLog}
      cat \$1 >> ${traceLog}
      echo >> ${traceLog}
      EOF
      chmod +x $out/bin/steamdeps
    ''}
    install -d $out/lib/udev/rules.d
    install -m644 lib/udev/rules.d/*.rules $out/lib/udev/rules.d
  '';

  meta = with stdenv.lib; {
    description = "A digital distribution platform";
    homepage = "http://store.steampowered.com/";
    license = licenses.unfreeRedistributable;
    maintainers = with maintainers; [ jagajaga ];
  };
}
