source $stdenv/setup

tar xvfz $src
mv SABnzbd-* $out

-- Create a start script and let wrapProgram with toPythonPath wrap it so that python is started with cheetahTemplate in its importpath (classpath)
mkdir $out/bin
echo "$python/bin/python $out/SABnzbd.py" > $out/bin/sabnzbd.sh
chmod +x $out/bin/sabnzbd.sh

for i in $(cd $out/bin && ls); do
  wrapProgram $out/bin/$i \
    --prefix PYTHONPATH : "$(toPythonPath $python):$(toPythonPath $out):$(toPythonPath $cheetahTemplate)"
done

echo $out
