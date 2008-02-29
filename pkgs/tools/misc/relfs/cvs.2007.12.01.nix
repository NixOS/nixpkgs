args : with args;
	let localDefs = builderDefs {
	src = /* put a fetchurl here */
	if args ? src then args.src else fetchcvs {
		cvsRoot = ":pserver:anonymous@relfs.cvs.sourceforge.net:/cvsroot/relfs";
		module = "relfs";
		date = "2007-12-01";
		sha256 = "ef8e2ebfda6e43240051a7af9417092b2af50ece8b5c6c3fbd908ba91c4fe068";
	};
		
		buildInputs = [ocaml fuse postgresql pcre
			e2fsprogs gnomevfs pkgconfig GConf];
		configureFlags = [];
	} null; /* null is a terminator for sumArgs */
	in with localDefs;
let build = FullDepEntry ("
	cd deps 
	sed -e 's/^CPP/#&/ ; s/^# CPP=gcc/CPP=gcc/' -i Makefile.camlidl
	make 
	cd ../src
	sed -e 's/NULL\\|FALSE/0/g' -i Mimetype_lib.c
	sed -e 's@/usr/local/@'\$out/'@' -i Makefile
	sed -e '/install:/a\\\tmkdir -p '\$out'/share' -i Makefile
	make
	mkdir -p \$out/bin
	echo '
		createuser -A -D \$1
		dropdb relfs_\$1 ; 
		rm -rf /tmp/relfs-\$1-tmp;  
		mkdir /tmp/relfs-\$1-tmp;  
		USER=\$1 relfs -f -s /tmp/relfs-raskin-tmp  & 
		sleep 1 && 
		kill -15 \${!};
		rm -rf /tmp/relfs-\$1-tmp ; 
		psql -d relfs_\$1 <<< \"ALTER DATABASE relfs_raskin OWNER TO raskin; 
			ALTER TABLE obj OWNER TO \$1; 
			ALTER TABLE obj_mimetype OWNER TO \$1; 
			ALTER TABLE membership OWNER TO \$1;\"' > \$out/bin/relfs_grant;
	chmod a+x \$out/bin/relfs_grant;
") [minInit doUnpack addInputs];
in
stdenv.mkDerivation rec {
	name = "relfs-"+version;
	builder = writeScript (name + "-builder")
		(textClosure localDefs [build doMakeInstall doForceShare doPropagate]);
	meta = {
		description = "
	Relational FS over FUSE.
";
	};
}
