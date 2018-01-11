{lib, stdenv, fetchFromGitHub, python, buildPythonPackage, isPyPy, isPy27, numpy, nose,
 enum34, pythonOlder, futures}:

buildPythonPackage rec {
  pname = "tifffile";
  rev = "v0.13.0";
  name = "${pname}-${rev}";

  src = fetchFromGitHub {
    owner = "blink1073";
    repo = "tifffile";
    inherit rev;
    sha256 = "0adm1zf3b4gf8yjriidjnl9abcycqiy5bzannwyb8rcbh3jwdbzv";
  };

  buildInputs = [ nose ];
    
  propagatedBuildInputs = [ numpy ] ++ lib.optional isPy27 futures ++ lib.optional (pythonOlder "3.0") enum34;

  meta = {
    description = "Read and write image data from and to TIFF files.";
    homepage = https://github.com/blink1073/tifffile;
    maintainers = with lib.maintainers; [ lebastr ];
  };
}
