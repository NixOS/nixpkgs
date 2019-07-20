{ stdenv, python3Packages, fetchFromGitHub }:

python3Packages.buildPythonApplication rec {
  pname = "bashplotlib";
  version = "2019-01-02";

  src = fetchFromGitHub {
    owner = "glamp";
    repo = "bashplotlib";
    rev = "f7533172c4dc912b5accae42edd5c0f655d7468f";
    sha256 = "1sifqslvvz2c05spwrl81kcdg792l6jwvfd3ih9q5wjkvkm0plz8";
  };

  # No tests
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/glamp/bashplotlib;
    description = "Plotting in the terminal";
    maintainers = with maintainers; [ dtzWill ];
    license = licenses.mit;
  };
}
