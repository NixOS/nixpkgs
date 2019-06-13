{ stdenv, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonPackage rec {

  version = "0.4";
  name = "lice-${version}";

  src = fetchFromGitHub {
    owner = "licenses";
    repo = "lice";
    rev = version;
    sha256 = "0yxf70fi8ds3hmwjply2815k466r99k8n22r0ppfhwjvp3rn60qx";
    fetchSubmodules = true;
  };

  meta = with stdenv.lib; {
    description = "Print license based on selection and user options.";
    homepage = https://github.com/licenses/lice;
    license = licenses.bsd3;
    maintainers = with maintainers; [ swflint ];
    platforms = platforms.unix;
  };

}
