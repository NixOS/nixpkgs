source $stdenv/setup

tar xvfz $src
mv SABnzbd-* $out

# Create a start script and let wrapProgram with toPythonPath wrap it so that python is started with cheetahTemplate in its importpath (classpath)
mkdir $out/bin
echo "$python/bin/python $out/SABnzbd.py \$*" > $out/bin/sabnzbd
chmod +x $out/bin/sabnzbd

for i in $(cd $out/bin && ls); do
  wrapProgram $out/bin/$i --prefix PYTHONPATH : "$(toPythonPath $python):$(toPythonPath $out):$(toPythonPath $cheetahTemplate):$(toPythonPath $sqlite3)" \
                          --prefix PATH : "$par2cmdline/bin:$unzip/bin:$unrar/bin"
done

echo $out
