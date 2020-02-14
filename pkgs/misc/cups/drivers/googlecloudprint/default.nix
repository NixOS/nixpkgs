{ stdenv, lib, fetchFromGitHub, python2, python2Packages, file, makeWrapper, cups }:

# Setup instructions can be found at https://github.com/simoncadman/CUPS-Cloud-Print#configuration
# So the nix version is something like:
# nix run nixpkgs.cups-googlecloudprint -c sudo setupcloudprint
# nix run nixpkgs.cups-googlecloudprint -c sudo listcloudprinters

let pythonEnv = python2.buildEnv.override {
  extraLibs = with python2Packages; [
    six
    httplib2
    pycups
  ];
};

in stdenv.mkDerivation rec {
  pname = "cups-googlecloudprint";
  version = "20160502";

  src = fetchFromGitHub {
    owner  = "simoncadman";
    repo   = "CUPS-Cloud-Print";
    rev    = version;
    sha256 = "0760i12w7jrhq7fsgyz3yqla5cvpjb45n6m2jz96wsy3p3xf6dzz";
  };

  buildInputs = [ cups makeWrapper ];

  cupsgroup = "nonexistantgroup";
  NOPERMS = 1;

  postConfigure = ''
    substituteInPlace Makefile --replace "${cups}" "$out"
  '';

  postInstall = ''
    pushd "$out"
    for s in lib/cups/backend/gcp lib/cups/driver/cupscloudprint
    do
      echo "Wrapping $s..."
      wrapProgram "$out/$s" --set PATH "${lib.makeBinPath [pythonEnv file]}" --prefix PYTHONPATH : "$out/share/cloudprint-cups"
    done

    mkdir bin

    for s in share/cloudprint-cups/*.py
    do
      if [ -x "$s" ] # Only wrapping those Python scripts marked as executable
      then
        o="bin/$(echo $s | sed 's,share/cloudprint-cups/\(.*\).py,\1,')"
        echo "Wrapping $o -> $s..."
        makeWrapper "$out/$s" "$o" --set PATH "${lib.makeBinPath [pythonEnv file]}" --prefix PYTHONPATH : "$out/share/cloudprint-cups"
      fi
    done
    popd
  '';

  meta = with stdenv.lib; {
    description = "Google Cloud Print driver for CUPS, allows printing to printers hosted on Google Cloud Print";
    homepage    = http://ccp.niftiestsoftware.com;
    platforms   = platforms.linux;
    license     = licenses.gpl3;
  };
}
