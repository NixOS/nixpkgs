{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
  wheel,
  # For tests
  stockfish,
  runCommand,
  python,
}:

buildPythonPackage rec {
  pname = "stockfish";
  version = "3.28.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-h2QSfABDSqhbf8ocBkgA5+qQe7NibM1LWD8OkRsBQHA=";
  };

  # The original setup.py requires pytest-runner which has been
  # removed from nixpkgs. We replace it with a minimal setup.py
  # that avoids this deprecated dependency.
  prePatch = ''
        cat > setup.py << 'EOF'
    from setuptools import setup, find_packages

    with open("README.md", "r", encoding="utf-8") as fh:
        long_description = fh.read()

    setup(
        name="stockfish",
        version="3.28.0",
        author="Ilya Zhelyabuzhsky",
        author_email="zhelyabuzhsky@icloud.com",
        description="Integrates the Stockfish chess engine with Python",
        long_description=long_description,
        long_description_content_type="text/markdown",
        url="https://github.com/zhelyabuzhsky/stockfish",
        packages=find_packages(),
        classifiers=[
            "Programming Language :: Python :: 3",
            "License :: OSI Approved :: MIT License",
            "Operating System :: OS Independent",
        ],
        python_requires='>=3.7',
    )
    EOF
  '';

  build-system = [
    setuptools
    wheel
  ];

  # Tests require network access and additional setup
  doCheck = false;

  pythonImportsCheck = [ "stockfish" ];

  passthru.tests = {
    # Basic import test
    basic-import =
      runCommand "stockfish-test-import"
        {
          buildInputs = [ (python.withPackages (ps: [ ps.stockfish ])) ];
        }
        ''
          python3 -c "from stockfish import Stockfish; print('✓ ok')"
          touch $out
        '';
  };

  meta = {
    description = "Integrates the Stockfish chess engine with Python";
    homepage = "https://github.com/zhelyabuzhsky/stockfish";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jamerrq ];
    longDescription = ''
      Python wrapper for the Stockfish chess engine. Requires the stockfish
      chess engine binary to be available in PATH or specified explicitly.

      Usage with Nix:
      nix-shell -p 'python3.withPackages (ps: [ ps.stockfish ])' stockfish
    '';
  };
}
