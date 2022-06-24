{ sip, fetchPypi, ply }:

# separate sip package for pyqt6-builder
# to avoid rebuild of pyqt5

(sip.overridePythonAttrs (old: rec {
  pname = "sip-pyqt6";
  version = "6.6.2";

  src = fetchPypi {
    pname = "sip";
    inherit version;
    sha256 = "sha256-Dj76wcXf2OUlrlcUCSffJpk+E/WLidFXfDFPQQW/2Q0=";
  };

  # sip 6.5.1 -> 6.6.2
  propagatedBuildInputs = old.propagatedBuildInputs ++ [ ply ];

  patches = old.patches ++ [
    # cosmetic
    ./fix-unbuffer-make-output.patch
    ./feat-print-configure-summary.patch
    # debug helper
    ./debug-dump-generated-files.patch
    # build faster
    # example use: pkgs/development/python-modules/pyqt/6.nix
    # upstream issue https://www.riverbankcomputing.com/pipermail/pyqt/2022-June/044717.html
    ./feat-parallel-configure.patch
    ./abi_version.py-raise-exceptions-from.patch
    ./debug-wip.patch
    ./fix-UserException-text.patch
  ];

  # fix: support absolute filepath in name argument
  # upstream issue https://www.riverbankcomputing.com/pipermail/pyqt/2022-June/044700.html
  # required to build pyqt6
  postPatch = ''
    sed -i -E \
      's/(prefix_dir) \+ ([a-z_.]+)/os.path.join(\1, \2)/g' \
      sipbuild/distinfo/distinfo.py
  '';
}))
