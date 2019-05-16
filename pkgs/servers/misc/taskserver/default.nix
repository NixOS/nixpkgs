{ stdenv, fetchurl, cmake, libuuid, gnutls, makeWrapper }:

stdenv.mkDerivation rec {
  name = "taskserver-${version}";
  version = "1.1.0";

  enableParallelBuilding = true;

  src = fetchurl {
    url = "http://www.taskwarrior.org/download/taskd-${version}.tar.gz";
    sha256 = "1d110q9vw8g5syzihxymik7hd27z1592wkpz55kya6lphzk8i13v";
  };

  patchPhase = ''
    pkipath=$out/share/taskd/pki
    mkdir -p $pkipath
    cp -r pki/* $pkipath
    echo "patching paths in pki/generate"
    sed -i "s#^\.#$pkipath#" $pkipath/generate
    for f in $pkipath/generate* ;do
      i=$(basename $f)
      echo patching $i
      sed -i \
          -e 's/which/type -p/g' \
          -e 's#^\. ./vars#if test -e ./vars;then . ./vars; else echo "cannot find ./vars - copy the template from '$pkipath'/vars into the working directory";exit 1; fi#' $f

      echo wrapping $i
      makeWrapper  $pkipath/$i $out/bin/taskd-pki-$i \
        --prefix PATH : ${stdenv.lib.makeBinPath [ gnutls ]}
    done
  '';

  buildInputs = [ makeWrapper ];
  nativeBuildInputs = [ cmake libuuid gnutls ];

  meta = {
    description = "Server for synchronising Taskwarrior clients";
    homepage = https://taskwarrior.org;
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ matthiasbeyer makefu ];
  };
}
