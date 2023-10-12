{ lib
, fetchPypi
, gobject-introspection
, libblockdev
, libbytesize
, parted
, python3
}:

let
  pname = "blivet";
  version = "3.8.1";
in
python3.pkgs.buildPythonApplication {
  inherit pname version;
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-cvgE1/lA24lzGj1eFSFR8w6GZaaZLUoMclzWZK9VNKU=";
  };

  # FIXME: unable to make tests work.
  # ValueError: Namespace BlockDev not available
  # Relevant Issue: https://github.com/storaged-project/blivet/issues/894
  doCheck = false;

  # checkPhase = ''
  #   runHook preCheck
  #   make test
  #   runHook postCheck
  # '';

  propagatedBuildInputs = [
    gobject-introspection
    libblockdev
    libbytesize
    parted
  ] ++ (with python3.pkgs; [
    six
    pyaml
    pyparted
    pygobject3
  ]);

  meta = with lib; {
    description = "A python module for configuration of block devices";
    homepage = "https://github.com/storaged-project/blivet";
    license = with lib.licenses; [ lgpl2Plus gpl2Plus ];
    maintainers = with maintainers; [ jfvillablanca ];
    platforms = lib.platforms.linux;
  };
}
