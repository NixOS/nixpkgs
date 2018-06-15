{ stdenv, fetchurl, python3Packages }:

let

  name = "doit";
  version = "0.31.1";

in python3Packages.buildPythonApplication {
  name = "${name}-${version}";

  src = fetchurl {
    url = "mirror://pypi/d/${name}/${name}-${version}.tar.gz";
    sha256 = "1spm8vfjh4kvalaj0i2ggbdln1yy5k68d8mfwfnpqlzxxx4ikl5s";
  };

  buildInputs = with python3Packages; [ mock pytest ];

  propagatedBuildInputs = with python3Packages; [ cloudpickle pyinotify ];

  # Tests fail due to mysterious gdbm.open() resource temporarily
  # unavailable errors.
  doCheck = false;
  checkPhase = "py.test";

  meta = {
    homepage = http://pydoit.org/;
    description = "A task management & automation tool";
    license = stdenv.lib.licenses.mit;
    longDescription = ''
      doit is a modern open-source build-tool written in python
      designed to be simple to use and flexible to deal with complex
      work-flows. It is specially suitable for building and managing
      custom work-flows where there is no out-of-the-box solution
      available.
    '';
    platforms = stdenv.lib.platforms.all;
  };
}
