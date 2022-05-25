{ lib, stdenv, fetchurl, runtimeShell, traceDeps ? false, bash }:

let
  traceLog = "/tmp/steam-trace-dependencies.log";
  version = "1.0.0.74";

in stdenv.mkDerivation {
  pname = "steam-original";
  inherit version;

  src = fetchurl {
    # use archive url so the tarball doesn't 404 on a new release
    url = "https://repo.steampowered.com/steam/archive/stable/steam_${version}.tar.gz";
    sha256 = "sha256-sO07g3j1Qejato2LWJ2FrW3AzfMCcBz46HEw7aKxojQ=";
  };

  makeFlags = [ "PREFIX=$(out)" ];

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

    # Use PATH to find steam, as /usr/bin/ path will always fail
    substituteInPlace $out/share/applications/steam.desktop \
      --replace "/usr/bin/steam" "steam"
  '';

  meta = with lib; {
    description = "A digital distribution platform";
    homepage = "https://store.steampowered.com/";
    license = licenses.unfreeRedistributable;
    maintainers = with maintainers; [ jagajaga jonringer ];
  };
}
