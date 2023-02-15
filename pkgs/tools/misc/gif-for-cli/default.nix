{ lib, fetchFromGitHub, python3Packages, ffmpeg, zlib, libjpeg }:

python3Packages.buildPythonApplication {
  pname = "gif-for-cli";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "google";
    repo = "gif-for-cli";
    rev = "31f8aa2d617d6d6e941154f60e287c38dd9a74d5";
    sha256 = "Bl5o492BUAn1KsscnlMIXCzJuy7xWUsdnxIKZKaRM3M=";
  };

  nativeCheckInputs = [ python3Packages.coverage ];
  buildInputs = [ zlib libjpeg ];
  propagatedBuildInputs = with python3Packages; [ ffmpeg pillow requests x256 ];

  meta = with lib; {
    description = "Render gifs as ASCII art in your cli";
    longDescription = "Takes in a GIF, short video, or a query to the Tenor GIF API and converts it to animated ASCII art.";
    homepage = "https://github.com/google/gif-for-cli";
    license = licenses.asl20;
    maintainers = with maintainers; [ Scriptkiddi ];
  };

}
