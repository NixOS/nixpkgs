{ stdenv, fetchurl, fam }:

stdenv.mkDerivation rec {
  name = "fileschanged-0.6.9";

  src = fetchurl {
    url = "mirror://savannah/fileschanged/${name}.tar.gz";
    sha256 = "0ajc9h023vzpnlqqjli4wbvs0q36nr5p9msc3wzbic8rk687qcxc";
  };

  buildInputs = [ fam ];

  patches = [./unused-variables.debian.patch];

  doCheck = true;

  meta = {
    homepage = http://www.nongnu.org/fileschanged/;
    description = "A command-line utility that reports when files have been altered";
    license = stdenv.lib.licenses.gpl3Plus;

    longDescription = ''
      This utility is a client to FAM (File Alteration Monitor) servers
      like FAM or Gamin. You give it some filenames on the command line
      and then it monitors those files for changes. When it discovers
      that a file has been altered, it displays the filename on the
      standard-output or executes a given command.
    '';

    platforms = stdenv.lib.platforms.linux;
  };
}
