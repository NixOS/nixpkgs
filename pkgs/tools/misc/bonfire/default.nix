{ stdenv, python3Packages, fetchFromGitHub }:

with python3Packages;

buildPythonApplication rec {
  version = "2017-01-19";
  pname = "bonfire";
  name = "${pname}-unstable-${version}";

  # use latest git version with --endpoint flag
  # https://github.com/blue-yonder/bonfire/pull/18
  src = fetchFromGitHub {
    owner = "blue-yonder";
    repo = "${pname}";
    rev = "d0af9ca10394f366cfa3c60f0741f1f0918011c2";
    sha256 = "193zcvzbhxwwkwbgmnlihhhazwkajycxf4r71jz1m12w301sjhq5";
  };

  postPatch = ''
    # https://github.com/blue-yonder/bonfire/pull/24
    substituteInPlace requirements.txt \
      --replace "arrow>=0.5.4,<0.8" "arrow>=0.5.4" \
      --replace "keyring>=9,<10"    "keyring>=9" \
      --replace "click>=3.3,<7"     "click>=3.3"
    # pip fails when encountering the git hash for the package version
    substituteInPlace setup.py \
      --replace "version=version," "version='${version}',"
    # remove extraneous files  
    substituteInPlace setup.cfg \
      --replace "data_files = *.rst, *.txt" ""
  '';

  buildInputs = [ httpretty pytest pytestcov ];

  propagatedBuildInputs = [ arrow click keyring parsedatetime requests six termcolor ];

  meta = with stdenv.lib; {
    homepage = https://pypi.python.org/pypi/bonfire;
    description = "CLI Graylog Client with Follow Mode";
    license = licenses.bsd3;
    maintainers = [ maintainers.womfoo ];
    platforms = platforms.linux;
  };

}
