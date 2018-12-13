{ stdenv, fetchFromGitHub, python3Packages, ffmpeg, zlib, libjpeg }:

python3Packages.buildPythonApplication rec {
  name = "gif-for-cli";

  meta = with stdenv.lib; {
    homepage = https://github.com/google/gif-for-cli;
    description = "Takes in a GIF, short video, or a query to the Tenor GIF API and converts it to animated ASCII art.";
    license = licenses.apache2;
    maintainers = with maintainers; [ scriptkiddi ];
    platforms = platforms.linux;
  };

  checkInputs = [ python3Packages.coverage ];

  src = fetchFromGitHub {
    owner = "google";
    repo = "gif-for-cli";
    rev = "master";
    sha256 = "1rj8wjfsabn27k1ds7a5fdqgf2r28zpz4lvhbzssjfj1yf0mfh7s";
  };

  propagatedBuildInputs = [ ffmpeg zlib libjpeg python3Packages.pillow python3Packages.requests python3Packages.x256 ];
}
