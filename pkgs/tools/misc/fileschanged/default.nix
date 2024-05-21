{ lib, stdenv, fetchurl, gamin }:

stdenv.mkDerivation rec {
  pname = "fileschanged";
  version = "0.6.9";

  src = fetchurl {
    url = "mirror://savannah/fileschanged/fileschanged-${version}.tar.gz";
    sha256 = "0ajc9h023vzpnlqqjli4wbvs0q36nr5p9msc3wzbic8rk687qcxc";
  };

  buildInputs = [ gamin ];

  patches = [./unused-variables.debian.patch];

  doCheck = true;

  meta = {
    homepage = "https://www.nongnu.org/fileschanged/";
    description = "A command-line utility that reports when files have been altered";
    license = lib.licenses.gpl3Plus;

    longDescription = ''
      This utility is a client to FAM (File Alteration Monitor) servers
      like FAM or Gamin. You give it some filenames on the command line
      and then it monitors those files for changes. When it discovers
      that a file has been altered, it displays the filename on the
      standard-output or executes a given command.
    '';

    platforms = lib.platforms.linux;
    mainProgram = "fileschanged";
  };
}
