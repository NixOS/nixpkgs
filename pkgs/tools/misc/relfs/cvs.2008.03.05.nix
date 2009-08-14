
args : with args;
	let localDefs = builderDefs.passthru.function {
	src = /* put a fetchurl here */
	if args ? src then args.src else fetchcvs {
		cvsRoot = ":pserver:anonymous@relfs.cvs.sourceforge.net:/cvsroot/relfs";
		module = "relfs";
		date = "2008-03-05";
		sha256 = "949f8eff7e74ff2666cccf8a1efbfcce8d54bc41bec6ad6db8c029de7ca832a3";
	};
		
		buildInputs = [ocaml fuse postgresql pcre
			libuuid gnomevfs pkgconfig GConf];
		configureFlags = [];
		    build = builderDefs.stringsWithDeps.fullDepEntry ("
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
				USER=\$1 relfs -f -s /tmp/relfs-\$1-tmp  & 
				sleep 1 && 
				kill -15 \${!};
				rm -rf /tmp/relfs-\$1-tmp ; 
				psql -d relfs_\$1 <<< \"ALTER DATABASE relfs_\$1 OWNER TO \$1; 
					ALTER TABLE obj OWNER TO \$1; 
					ALTER TABLE obj_mimetype OWNER TO \$1; 
					ALTER TABLE membership OWNER TO \$1;\"' > \$out/bin/relfs_grant;
			chmod a+x \$out/bin/relfs_grant;
		") ["minInit" "doUnpack" "addInputs"];
	};
	in with localDefs;
stdenv.mkDerivation rec {
	name = "relfs-"+version;
	builder = writeScript (name + "-builder")
		(textClosure localDefs ["build" "doMakeInstall" "doForceShare" "doPropagate"]);
	meta = {
		description = "A relational filesystem on top of FUSE";
		inherit src;
    		maintainers = [args.lib.maintainers.raskin];
	};
}
