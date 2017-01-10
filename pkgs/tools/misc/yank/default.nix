{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {

  name = "yank-${meta.version}";

  src = fetchFromGitHub {
    owner = "mptre";
    repo = "yank";
    rev = "v${meta.version}";
    sha256 = "1m8pnarm8n5x6ylbzxv8j9amylrllw166arrj4cx9f2jp2zbzcic";
    inherit name;
  };

  installPhase = ''
    make PREFIX=$out install
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/mptre/yank";
    description = "Yank terminal output to clipboard";
    longDescription = ''
      Read input from stdin and display a selection interface that allows a
      field to be selected and copied to the clipboard. Fields are determined
      by splitting the input on a delimiter sequence, optionally specified
      using the -d option. New line, carriage return and tab characters are
      always treated as delimiters.
    '';
    downloadPage = "https://github.com/mptre/yank/releases";
    license = licenses.mit;
    version = "0.7.1";
    maintainers = [ maintainers.dochang ];
    platforms = platforms.unix;
  };

}
