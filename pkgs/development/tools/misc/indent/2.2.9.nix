args : with args;
	let localDefs = builderDefs.passthru.function {
		src = /* put a fetchurl here */
		fetchurl {
			url = ftp://ftp.gnu.org/gnu/indent/indent-2.2.9.tar.gz;
			sha256 = "0rp4divzv5xyflm8ixpp2isa092n0nmhgmhvz56db7k3lnyqg4qb";
		};

		buildInputs = [];
		configureFlags = [];
	};
	in with localDefs;
let 
	preBuild = FullDepEntry ("
		sed -e '/extern FILE [*]output/i#ifndef OUTPUT_DEFINED_ELSEWHERE' -i src/indent.h
		sed -e '/extern FILE [*]output/a#endif' -i src/indent.h
		sed -e '1i#define OUTPUT_DEFINED_ELSEWHERE 1' -i src/output.c
	") [minInit doUnpack];
in
stdenv.mkDerivation rec {
	name = "indent";
	builder = writeScript (name + "-builder")
		(textClosure localDefs [doConfigure preBuild doMakeInstall doForceShare doPropagate]);
	meta = {
		description = "GNU Indent - a source text formatter";
		inherit src;
	};
}
