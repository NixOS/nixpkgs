{ lib, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "base16-shell-preview";
  version = "1.0.0";

  src = python3Packages.fetchPypi {
    inherit version;
    pname = "base16_shell_preview";
    sha256 = "098f3z81g3acgcrisipz0nh17n9kx7ld6h8dg26qz3nx31pngsxd";
  };

  # No tests
  # If enabled, will attempt to run '__init__.py, and will fail with "/homeless-shelter" as HOME
  doCheck = false;

  meta = with lib; {
    description = "Browse and preview Base16 Shell themes in your terminal";
    homepage = "https://github.com/nvllsvm/base16-shell-preview";
    license = licenses.mit;
    maintainers = [ maintainers.rencire ];
  };
}
