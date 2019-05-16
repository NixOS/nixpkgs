{ stdenv, fetchFromGitHub, python3Packages, ffmpeg, zlib, libjpeg }:

python3Packages.buildPythonApplication rec {
  pname = "gif-for-cli";
  version = "unstable-2018-08-14";

  src = fetchFromGitHub {
    owner = "google";
    repo = "gif-for-cli";
    rev = "9696f25fea2e38499b7c248a3151030c3c68bb00";
    sha256 = "1rj8wjfsabn27k1ds7a5fdqgf2r28zpz4lvhbzssjfj1yf0mfh7s";
  };

  checkInputs = [ python3Packages.coverage ];
  buildInputs = [ ffmpeg zlib libjpeg ];
  propagatedBuildInputs = with python3Packages; [ pillow requests x256 ];

  meta = with stdenv.lib; {
    description = "Render gifs as ASCII art in your cli";
    longDescription = "Takes in a GIF, short video, or a query to the Tenor GIF API and converts it to animated ASCII art.";
    homepage = https://github.com/google/gif-for-cli;
    license = licenses.asl20;
    maintainers = with maintainers; [ Scriptkiddi ];
  };

}
