args: with args;
stdenv.mkDerivation {
  name = "thePenguinMachine";

  src = fetchurl {
		url = http://www.migniot.com/matrix/projects/thepenguinmachine/ThePenguinMachine.tar.gz;
		sha256 = "09ljks8vj75g00h3azc83yllbfsrxwmv1c9g32gylcmsshik0dqv";
	};

  buildInputs = [python24 pil pygame SDL];

  configurePhase = "
		sed -e \"/includes = /aincludes.append('${SDL}/include/SDL')\" -i setup.py;
		sed -e \"/includes = /aincludes.append('${pygame}/include/python2.4')\" -i setup.py;
		cat setup.py;
	";
  buildPhase = "
		python setup.py build;
		python setup.py build_clib;
		python setup.py build_ext;
		python setup.py build_py;
		python setup.py build_scripts;
		";
  installPhase = "
		python setup.py install --prefix=\${out}
		cp -r . /tmp/tpm-build
		echo 'export PYTHONPATH=$PYTHONPATH:${pygame}/lib/python2.4/site-packages:${pil}/lib/python2.4/site-packages/PIL
		python ThePenguinMachine.py' >/tmp/tpm-build/tpm.sh; 
		chmod a+rx /tmp/tpm-build/tpm.sh
		";

  meta = {
    description = "
	The Penguin Machine - an Incredible Machine clone.
";
  };
}
