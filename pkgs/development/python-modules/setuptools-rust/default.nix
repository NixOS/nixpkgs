{ lib
, buildPythonPackage
, fetchFromGitHub
, pkgs
  # Python Packages
, semantic-version
, toml
  # Check inputs
, pytest
, python
}:

buildPythonPackage rec {
  pname = "setuptools-rust";
  version = "0.10.6";

  src = fetchFromGitHub {
    owner = "PyO3";
    repo = "setuptools-rust";
    rev = "v${version}";
    sha256 = "19q0b17n604ngcv8lq5imb91i37frr1gppi8rrg6s4f5aajsm5fm";
  };

  # buildInputs = [
  #   pkgs.cargo
  #   pkgs.rustc
  # ];

  propagatedBuildInputs = [
    # pkgs.cargo
    # pkgs.rustc  # permanent linking doesn't work as I hoped...
    semantic-version
    toml
  ];

  doCheck = true;
  checkInputs = [ python pytest pkgs.rustc pkgs.cargo ];
  dontUseSetuptoolsCheck = true;

  # From .travis.yml:
  checkPhase = ''
    # pushd example_tomlgen
    # DISTUTILS_DEBUG=1 python setup.py tomlgen_rust -w build
    # popd

    pushd html-py-ever
    cp ../nix_run_setup .
    DISTUTILS_DEBUG=1 python nix_run_setup install --prefix="$out"
    pytest
  '';

  meta = with lib; {
    description = "Setuptools plugin for Rust support.";
    homepage = "";
    license = licenses.mit;
    maintainers = with maintainers; [ drewrisinger ];
  };
}
