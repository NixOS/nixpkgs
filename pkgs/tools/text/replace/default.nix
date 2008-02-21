{stdenv, fetchurl}:

stdenv.mkDerivation ({
  name = "replace-2.24";

  src = fetchurl {
    url = ftp://hpux.connect.org.uk/hpux/Users/replace-2.24/replace-2.24-src-11.11.tar.gz;
    sha256 = "1c2nkxx83vmlh1v3ib6r2xqh121gdb1rharwsimcb2h0xwc558dm";
  };

  makeFlags = "TREE=\$(out)";

  postInstall = "mv \$out/bin/replace \$out/bin/replace-literal";

  meta = {
    homepage = http://replace.richardlloyd.org.uk/;
    description = "A tool to replace verbatim strings";
  };
} // (if stdenv.system == "i686-darwin" then {patches = [./malloc.patch];} else {}))
