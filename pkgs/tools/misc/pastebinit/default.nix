{ stdenv, fetchurl, python3Packages }:

python3Packages.buildPythonPackage rec {
  version = "1.4.1";
  name = "pastebinit-${version}";

  src = fetchurl {
    url = "https://launchpad.net/pastebinit/trunk/${version}/+download/${name}.tar.bz2";
    sha256 = "1rl854izwn1fpaaib6zj7a1a9bis8n7w4zfxcapgfffj37zj0dy2";
  };

  configurePhase = "export DETERMINISTIC_BUILD=1";

  buildPhase = "";

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/etc
    cp -a pastebinit $out/bin
    cp -a pastebin.d $out/etc
    substituteInPlace $out/bin/pastebinit --replace "'/etc/pastebin.d" "'$out/etc/pastebin.d"
  '';

  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://launchpad.net/pastebinit;
    description = "A software that lets you send anything you want directly to a pastebin from the command line";
    maintainers = with maintainers; [ lethalman ];
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
