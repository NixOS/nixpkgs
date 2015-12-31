source $stdenv/setup

tar xvfz $src
mv SABnzbd-* $out

mkdir $out/bin
echo "$python/bin/python $out/SABnzbd.py \$*" > $out/bin/sabnzbd
chmod +x $out/bin/sabnzbd

wrapPythonProgramsIn $out/bin "$pythonPath"
wrapProgram $out/bin/.sabnzbd-wrapped --prefix PATH : "$par2cmdline/bin:$unzip/bin:$unrar/bin"

echo $out
