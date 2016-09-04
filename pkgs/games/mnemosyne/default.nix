{ stdenv
, fetchurl
, pythonPackages
}:
let
  version = "2.3.2";
in pythonPackages.buildPythonApplication rec {
  name = "mnemosyne-${version}";
  src = fetchurl {
    url    = "http://sourceforge.net/projects/mnemosyne-proj/files/mnemosyne/${name}/Mnemosyne-${version}.tar.gz";
    sha256 = "0jkrw45i4v24p6xyq94z7rz5948h7f5dspgs5mcdaslnlp2accfp";
  };
  propagatedBuildInputs = with pythonPackages; [
    pyqt4
    matplotlib
    cherrypy
    sqlite3
    webob
  ];
  preConfigure = ''
    substituteInPlace setup.py --replace /usr $out
    find . -type f -exec grep -H sys.exec_prefix {} ';' | cut -d: -f1 | xargs sed -i s,sys.exec_prefix,\"$out\",
  '';
  meta = {
    homepage = http://mnemosyne-proj.org/;
    description = "Spaced-repetition software";
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
