{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication {
  pname = "bashplotlib";
  version = "2021-03-31";

  src = fetchFromGitHub {
    owner = "glamp";
    repo = "bashplotlib";
    rev = "db4065cfe65c0bf7c530e0e8b9328daf9593ad74";
    sha256 = "sha256-0S6mgy6k7CcqsDR1kE5xcXGidF1t061e+M+ZuP2Gk3c=";
  };

  # No tests
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/glamp/bashplotlib";
    description = "Plotting in the terminal";
    maintainers = with maintainers; [ dtzWill ];
    license = licenses.mit;
  };
}
