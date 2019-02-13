{ stdenv, buildPythonPackage, fetchFromGitHub }:

buildPythonPackage rec {
  pname = "me_cleaner";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "corna";
    repo = pname;
    rev = "v${version}";
    sha256 = "1bdj2clm13ir441vn7sv860xsc5gh71ja5lc2wn0gggnff0adxj4";
  };

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "Tool for partial deblobbing of Intel ME/TXE firmware images";
    longDescription = ''
      me_cleaner is a Python script able to modify an Intel ME firmware image
      with the final purpose of reducing its ability to interact with the system.
    '';
    license = licenses.gpl3;
    maintainers = with maintainers; [ gnidorah ];
  };
}
