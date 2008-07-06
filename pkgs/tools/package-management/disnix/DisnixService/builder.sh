source $stdenv/setup

cp -av $src/* .
find . -type f | while read i
do
    chmod 644 "$i"
done
find . -type d | while read i
do
    chmod 755 "$i"
done
export AXIS2_LIB=$axis2/share/java/axis2
ant generate.library.jar
ant generate.service.aar
ensureDir $out/shared/lib
cp *.jar *.so $out/shared/lib
chmod 755 $out/shared/lib/*.so
ensureDir $out/webapps/axis2/WEB-INF/services
cp DisnixService.aar $out/webapps/axis2/WEB-INF/services
