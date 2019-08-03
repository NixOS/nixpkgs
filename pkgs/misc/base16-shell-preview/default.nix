{ lib, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "base16-shell-preview";
  version = "0.3.0";

  src = python3Packages.fetchPypi {
    inherit version;
    pname = "base16_shell_preview";
    sha256 = "0x2fbicrcqgf2dl7dqzm14dz08vjjziabaaw33wah3v9wv4rw7jq";
  };

  # No tests
  # If enabled, will attempt to run '__init__.py, and will fail with "/homeless-shelter" as HOME
  doCheck = false;

  meta = with lib; {
    description = "Browse and preview Base16 Shell themes in your terminal";
    homepage = https://github.com/nvllsvm/base16-shell-preview;
    license = licenses.mit;
    maintainers = [ maintainers.rencire ];
  };
}
