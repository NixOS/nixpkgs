{
  lib,
  stdenv,
  fetchurl,
  cmake,
  libuuid,
  gnutls,
  makeWrapper,
}:

stdenv.mkDerivation rec {
  pname = "taskserver";
  version = "1.1.0";

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
        --prefix PATH : ${lib.makeBinPath [ gnutls ]}
    done
  '';

  buildInputs = [
    libuuid
    gnutls
  ];
  nativeBuildInputs = [
    cmake
    makeWrapper
  ];

  meta = {
    description = "Server for synchronising Taskwarrior clients";
    homepage = "https://taskwarrior.org";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      matthiasbeyer
      makefu
    ];
  };
}
