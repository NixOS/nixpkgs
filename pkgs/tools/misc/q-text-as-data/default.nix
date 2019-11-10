{ stdenvNoCC, fetchFromGitHub, python2 }:

stdenvNoCC.mkDerivation rec {
  pname = "q-text-as-data";
  version = "1.7.4";

  src = fetchFromGitHub {
    owner = "harelba";
    repo = "q";
    rev = version;
    sha256 = "0p8rbfwwcqjyrix51v52zp9b03z4xg1fv2raf2ygqp9a4l27dca8";
  };

  buildInputs = [ python2 ];
  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    cp bin/q $out/bin
    chmod +x $out/bin/q
  '';

  meta = with stdenvNoCC.lib; {
    description = "Run SQL directly on CSV or TSV files";
    longDescription = ''
      q is a command line tool that allows direct execution of SQL-like queries on CSVs/TSVs (and any other tabular text files).

      q treats ordinary files as database tables, and supports all SQL constructs, such as WHERE, GROUP BY, JOINs etc. It supports automatic column name and column type detection, and provides full support for multiple encodings.
    '';
    homepage = "http://harelba.github.io/q/";
    license = licenses.gpl3;
    maintainers = [ maintainers.taneb ];
    platforms = platforms.all;
  };
}
