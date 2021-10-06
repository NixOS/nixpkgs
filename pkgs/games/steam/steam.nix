{ lib, stdenv, fetchurl, runtimeShell, traceDeps ? false, bash }:

let
  traceLog = "/tmp/steam-trace-dependencies.log";
  version = "1.0.0.72";

in stdenv.mkDerivation {
  pname = "steam-original";
  inherit version;

  src = fetchurl {
    url = "https://repo.steampowered.com/steam/pool/steam/s/steam/steam_${version}.tar.gz";
    sha256 = "0l54ljnlnx289i1ssnss78251vyga726dnzsrhgnxwn1p1125m45";
  };

  makeFlags = [ "DESTDIR=$(out)" "PREFIX=" ];

  postInstall = ''
    rm $out/bin/steamdeps
    ${lib.optionalString traceDeps ''
      cat > $out/bin/steamdeps <<EOF
      #!${runtimeShell}
      echo \$1 >> ${traceLog}
      cat \$1 >> ${traceLog}
      echo >> ${traceLog}
      EOF
      chmod +x $out/bin/steamdeps
    ''}

    # install udev rules
    mkdir -p $out/etc/udev/rules.d/
    cp ./subprojects/steam-devices/*.rules $out/etc/udev/rules.d/
    substituteInPlace $out/etc/udev/rules.d/60-steam-input.rules \
      --replace "/bin/sh" "${bash}/bin/bash"

    # this just installs a link, "steam.desktop -> /lib/steam/steam.desktop"
    rm $out/share/applications/steam.desktop
    sed -e 's,/usr/bin/steam,steam,g' steam.desktop > $out/share/applications/steam.desktop
  '';

  meta = with lib; {
    description = "A digital distribution platform";
    homepage = "https://store.steampowered.com/";
    license = licenses.unfreeRedistributable;
    maintainers = with maintainers; [ jagajaga jonringer ];
  };
}
