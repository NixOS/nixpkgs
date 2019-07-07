{ stdenv, fetchurl, python3 }:

stdenv.mkDerivation rec {
  version = "1.5";
  name = "pastebinit-${version}";

  src = fetchurl {
    url = "https://launchpad.net/pastebinit/trunk/${version}/+download/${name}.tar.bz2";
    sha256 = "0mw48fgm9lyh9d3pw997fccmglzsjccf2y347gxjas74wx6aira2";
  };

  buildInputs = [ python3 ];

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/etc
    cp -a pastebinit $out/bin
    cp -a pastebin.d $out/etc
    substituteInPlace $out/bin/pastebinit --replace "'/etc/pastebin.d" "'$out/etc/pastebin.d"
  '';

  meta = with stdenv.lib; {
    homepage = https://launchpad.net/pastebinit;
    description = "A software that lets you send anything you want directly to a pastebin from the command line";
    maintainers = with maintainers; [ lethalman ];
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
