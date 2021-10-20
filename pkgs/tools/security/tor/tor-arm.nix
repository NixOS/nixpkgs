{ lib, stdenv, fetchurl, makeWrapper
, python2Packages, ncurses, lsof, nettools
}:

stdenv.mkDerivation rec {
  pname = "tor-arm";
  version = "1.4.5.0";

  src = fetchurl {
    url = "https://www.atagar.com/arm/resources/static/arm-${version}.tar.bz2";
    sha256 = "1yi87gdglkvi1a23hv5c3k7mc18g0rw7b05lfcw81qyxhlapf3pw";
  };

  nativeBuildInputs = [ makeWrapper python2Packages.python ];

  outputs = [ "out" "man" ];

  postPatch = ''
    substituteInPlace ./setup.py --replace "/usr/bin" "$out/bin"
    substituteInPlace ./src/util/connections.py \
      --replace "lsof -wnPi"   "${lsof}/bin/lsof"
    substituteInPlace ./src/util/torTools.py \
      --replace "netstat -npl" "${nettools}/bin/netstat -npl" \
      --replace "lsof -wnPi"   "${lsof}/bin/lsof"

    substituteInPlace ./arm --replace '"$0" = /usr/bin/arm' 'true'
    substituteInPlace ./arm --replace "python" "${python2Packages.python}/bin/python"

    for i in ./install ./arm ./src/gui/controller.py ./src/cli/wizard.py ./src/resources/torrcOverride/override.h ./src/resources/torrcOverride/override.py ./src/resources/arm.1 ./setup.py; do
      substituteInPlace $i --replace "/usr/share" "$out/share"
    done

    # fixes man page installation
    substituteInPlace ./setup.py --replace "src/resoureces" "src/resources"
  '';

  installPhase = ''
    mkdir -p $out/share/arm $out/bin $out/libexec
    python setup.py install --prefix=$out --docPath $out/share/doc/arm
    cp -R src/TorCtl $out/libexec

    wrapProgram $out/bin/arm \
      --prefix PYTHONPATH : "$(toPythonPath $out):$out/libexec:$PYTHONPATH" \
      --set TERMINFO "${ncurses.out}/share/terminfo" \
      --set TERM "xterm"
  '';

  meta = {
    description = "A terminal status monitor for Tor relays";
    homepage    = "https://www.atagar.com/arm/";
    license     = lib.licenses.gpl3;
    platforms   = lib.platforms.unix;
    maintainers = [ lib.maintainers.thoughtpolice ];
  };
}
