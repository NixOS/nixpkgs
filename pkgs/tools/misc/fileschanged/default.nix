{ stdenv, fetchurl, fam }:

stdenv.mkDerivation {
  name = "fileschanged-0.6.9";

  src = fetchurl {
    url = "http://nongnu.askapache.com/fileschanged/fileschanged-0.6.9.tar.gz";
    sha256 = "0ajc9h023vzpnlqqjli4wbvs0q36nr5p9msc3wzbic8rk687qcxc";
  };

  buildInputs = [ fam ];

  doCheck = true;

  meta = {
    homepage = "http://www.nongnu.org/fileschanged/";
    description = "A command-line utility that reports when files have been altered.";
    license = "GPL";

    longDescription = ''
      This utility is a client to FAM (File Alteration Monitor) servers
      like FAM or Gamin. You give it some filenames on the command line
      and then it monitors those files for changes. When it discovers
      that a file has been altered, it displays the filename on the
      standard-output or executes a given command.
    '';

    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
