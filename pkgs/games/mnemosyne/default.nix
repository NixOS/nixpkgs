{ stdenv
, fetchurl
, buildPythonPackage
, pyqt4
, matplotlib
, cherrypy
, sqlite3
}:
let 
  version = "2.2.1";
in buildPythonPackage rec {
  name = "mnemosyne-${version}";
  src = fetchurl {
    url    = "http://sourceforge.net/projects/mnemosyne-proj/files/mnemosyne/${name}/Mnemosyne-${version}.tar.gz";
    sha256 = "7f5dd06a879b9ab059592355412182ee286e78e124aa25d588cacf9e4ab7c423";
  };
  pythonPath = [
    pyqt4
    matplotlib
    cherrypy
    sqlite3
  ];
  preConfigure = ''
    substituteInPlace setup.py --replace /usr $out
    find . -type f -exec grep -H sys.exec_prefix {} ';' | cut -d: -f1 | xargs sed -i s,sys.exec_prefix,\"$out\",
  '';
  installCommand = "python setup.py install --prefix=$out";
  meta = {
    homepage = "http://mnemosyne-proj.org/";
    description = "Spaced-repetition software.";
    longDescription = ''
      The Mnemosyne Project has two aspects:

        * It's a free flash-card tool which optimizes your learning process.
        * It's a research project into the nature of long-term memory.

      We strive to provide a clear, uncluttered piece of software, easy to use
      and to understand for newbies, but still infinitely customisable through
      plugins and scripts for power users.

      ## Efficient learning

      Mnemosyne uses a sophisticated algorithm to schedule the best time for
      a card to come up for review. Difficult cards that you tend to forget
      quickly will be scheduled more often, while Mnemosyne won't waste your
      time on things you remember well.

      ## Memory research

      If you want, anonymous statistics on your learning process can be
      uploaded to a central server for analysis. This data will be valuable to
      study the behaviour of our memory over a very long time period. The
      results will be used to improve the scheduling algorithms behind the
      software even further.  
    '';
  };
}
