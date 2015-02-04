{ stdenv, fetchurl, jre, makeWrapper, bash }:

stdenv.mkDerivation rec {
	name = "kafka";
        version = "0.8.1.1";
	src = fetchurl {
		url = "http://www.mirrorservice.org/sites/ftp.apache.org/${name}/${version}/${name}_2.9.2-${version}.tgz";
		sha256 = "cb141c1d50b1bd0d741d68e5e21c090341d961cd801e11e42fb693fa53e9aaed";
	};

	buildInputs = [ makeWrapper jre ];

	installPhase = ''
		mkdir -p $out
		cp -R config libs $out
		mkdir -p $out/bin
		cp -R bin/${name}-*.sh $out/bin
		for i in $out/bin/${name}-*.sh; do
			wrapProgram $i \
				--set JAVA_HOME "${jre}" \
				--prefix PATH : "${bash}/bin"
		done
                
	'';

	meta = with stdenv.lib; {
		homepage = "http://kafka.apache.org";
		description = "Apache Kafka";
		license = licenses.asl20;
		maintainers = [ maintainers.boothead ];	
		platforms = platforms.unix;	
	};		

}
