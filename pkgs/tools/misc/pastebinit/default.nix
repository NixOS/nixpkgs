{ lib
, stdenv
, fetchurl
, fetchpatch
, python3
}:
stdenv.mkDerivation rec {
  version = "1.5";
  pname = "pastebinit";

  src = fetchurl {
    url = "https://launchpad.net/pastebinit/trunk/${version}/+download/${pname}-${version}.tar.bz2";
    sha256 = "0mw48fgm9lyh9d3pw997fccmglzsjccf2y347gxjas74wx6aira2";
  };

  buildInputs = [
    (python3.withPackages (p: [ p.distro ]))
  ];

  patchFlags = [ "-p0" ];

  patches = [
    # Required to allow pastebinit 1.5 to run on Python 3.8
    ./use-distro-module.patch
    # Required to remove the deprecation warning of FancyURLopener
    ./use-urllib-request.patch
    # Required because pastebin.com now redirects http requests to https
    (fetchpatch {
      name = "pastebin-com-https.patch";
      url = "https://bazaar.launchpad.net/~arnouten/pastebinit/pastebin-com-https/diff/264?context=3";
      sha256 = "0hxhhfcai0mll8qfyhdl3slmbf34ynb759b648x63274m9nd2kji";
    })
  ];

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/etc
    cp -a pastebinit $out/bin
    cp -a pastebin.d $out/etc
    substituteInPlace $out/bin/pastebinit --replace "'/etc/pastebin.d" "'$out/etc/pastebin.d"
  '';

  meta = with lib; {
    homepage = "https://launchpad.net/pastebinit";
    description = "A software that lets you send anything you want directly to a pastebin from the command line";
    maintainers = with maintainers; [ raboof ];
    license = licenses.gpl2;
    platforms = platforms.linux ++ lib.platforms.darwin;
  };
}
