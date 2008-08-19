args : with args;
	let localDefs = builderDefs.meta.function {
		src = /* put a fetchurl here */
		fetchurl {
			url = http://download.savannah.gnu.org/releases/dmidecode/dmidecode-2.9.tar.bz2;
			sha256 = "05g0ln400fhqjspg9h4x0a1dvmwiyjq5rk9q9kimxvywbg1b53l8";
		};

		buildInputs = [];
		configureFlags = [];
		makeFlags = "prefix=\$out";
	};
	in with localDefs;
stdenv.mkDerivation rec {
	name = "dmidecode-"+version;
	builder = writeScript (name + "-builder")
		(textClosure localDefs [ doMakeInstall doForceShare doPropagate]);
	meta = {
		description = "
		Tool to decode Desktop Management Interface and SBIOS data.
";
		inherit src;
	};
}
