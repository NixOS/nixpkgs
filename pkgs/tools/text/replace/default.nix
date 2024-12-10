{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "replace";
  version = "2.24";

  src = fetchurl {
    url = "http://hpux.connect.org.uk/ftp/hpux/Users/replace-${version}/replace-${version}-src-11.31.tar.gz";
    sha256 = "18hkwhaz25s6209n5mpx9hmkyznlzygqj488p2l7nvp9zrlxb9sf";
  };

  outputs = [
    "out"
    "man"
  ];

  makeFlags = [
    "TREE=\$(out)"
    "MANTREE=\$(TREE)/share/man"
    "CC=${stdenv.cc.targetPrefix}cc"
  ];

  preBuild = ''
    sed -e "s@/bin/mv@$(type -P mv)@" -i replace.h
  '';

  preInstall = "mkdir -p \$out/share/man";
  postInstall = "mv \$out/bin/replace \$out/bin/replace-literal";

  patches = [ ./malloc.patch ];

  meta = {
    description = "A tool to replace verbatim strings";
    homepage = "https://replace.richardlloyd.org.uk/";
    mainProgram = "replace-literal";
    platforms = lib.platforms.unix;
  };
}
