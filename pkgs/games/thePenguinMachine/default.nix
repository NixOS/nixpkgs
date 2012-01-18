{stdenv, fetchurl, python, pil, pygame, SDL} @ args: with args;
stdenv.mkDerivation {
  name = "thePenguinMachine";

  src = fetchurl {
		url = http://www.migniot.com/matrix/projects/thepenguinmachine/ThePenguinMachine.tar.gz;
		sha256 = "09ljks8vj75g00h3azc83yllbfsrxwmv1c9g32gylcmsshik0dqv";
	};

  buildInputs = [python pil pygame SDL];

  configurePhase = ''
		sed -e "/includes = /aincludes.append('${SDL}/include/SDL')" -i setup.py;
		sed -e "/includes = /aincludes.append('$(echo ${pygame}/include/python*)')" -i setup.py;
		cat setup.py;
		export NIX_LDFLAGS="$NIX_LDFLAGS -lgcc_s"
	'';
  buildPhase = ''
		sed -e "s/pygame.display.toggle_fullscreen.*/pass;/" -i tpm/Application.py
                sed -e 's@"Surface"@"pygame.Surface"@' -i src/surfutils.c
		python setup.py build;
		python setup.py build_clib;
		python setup.py build_ext;
		python setup.py build_py;
		python setup.py build_scripts;
		'';
  installPhase = ''
		python setup.py install --prefix=$out
		mkdir -p "$out"/share/tpm/
		cp -r .  "$out"/share/tpm/build-dir
		mkdir -p "$out/bin"
		echo "#! /bin/sh" >> "$out/bin/tpm"
		echo "export PYTHONPATH=\"\$PYTHONPATH:$PYTHONPATH:$(echo ${pil}/lib/python*/site-packages/PIL)\"" >> "$out/bin/tpm"
		echo "cd \"$out/share/tpm/build-dir\"" >> "$out/bin/tpm"
		echo "export PYTHONPATH=\"\$PYTHONPATH:$PYTHONPATH:$(echo ${pil}/lib/python*/site-packages/PIL)\"" >> "$out/bin/tpm"
		echo "${python}/bin/python \"$out\"/share/tpm/build-dir/ThePenguinMachine.py \"\$@\"" >> "$out/bin/tpm"
		chmod a+x "$out/bin/tpm"
		'';

  meta = {
    description = "
	The Penguin Machine - an Incredible Machine clone.
";
  };
}
