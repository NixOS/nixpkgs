{ stdenv
, buildPythonPackage
, fetchPypi
, pbr
, pip
, pkgs
, stevedore
, virtualenv
, virtualenv-clone
, python
}:

buildPythonPackage rec {
  pname = "virtualenvwrapper";
  version = "4.8.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "18d8e4c500c4c4ee794f704e050cf2bbb492537532a4521d1047e7dd1ee4e374";
  };

  # pip depend on $HOME setting
  preConfigure = "export HOME=$TMPDIR";

  buildInputs = [ pbr pip pkgs.which ];
  propagatedBuildInputs = [ stevedore virtualenv virtualenv-clone ];

  postPatch = ''
    for file in "virtualenvwrapper.sh" "virtualenvwrapper_lazy.sh"; do
      substituteInPlace "$file" --replace "which" "${pkgs.which}/bin/which"

      # We can't set PYTHONPATH in a normal way (like exporting in a wrapper
      # script) because the user has to evaluate the script and we don't want
      # modify the global PYTHONPATH which would affect the user's
      # environment.
      # Furthermore it isn't possible to just use VIRTUALENVWRAPPER_PYTHON
      # for this workaround, because this variable is well quoted inside the
      # shell script.
      # (the trailing " -" is required to only replace things like these one:
      # "$VIRTUALENVWRAPPER_PYTHON" -c "import os,[...] and not in
      # if-statements or anything like that.
      # ...and yes, this "patch" is hacky :)
      substituteInPlace "$file" --replace '"$VIRTUALENVWRAPPER_PYTHON" -' 'env PYTHONPATH="$VIRTUALENVWRAPPER_PYTHONPATH" "$VIRTUALENVWRAPPER_PYTHON" -'
    done
  '';

  postInstall = ''
    # This might look like a dirty hack but we can't use the makeWrapper function because
    # the wrapped file were then called via "exec". The virtualenvwrapper shell scripts
    # aren't normal executables. Instead, the user has to evaluate them.

    for file in "virtualenvwrapper.sh" "virtualenvwrapper_lazy.sh"; do
      local wrapper="$out/bin/$file"
      local wrapped="$out/bin/.$file-wrapped"
      mv "$wrapper" "$wrapped"

      # WARNING: Don't indent the lines below because that would break EOF
      cat > "$wrapper" << EOF
export PATH="${python}/bin:\$PATH"
export VIRTUALENVWRAPPER_PYTHONPATH="$PYTHONPATH:$(toPythonPath $out)"
source "$wrapped"
EOF

      chmod -x "$wrapped"
      chmod +x "$wrapper"
    done
  '';

  meta = with stdenv.lib; {
    description = "Enhancements to virtualenv";
    homepage = "https://pypi.python.org/pypi/virtualenvwrapper";
    license = licenses.mit;
  };

}
