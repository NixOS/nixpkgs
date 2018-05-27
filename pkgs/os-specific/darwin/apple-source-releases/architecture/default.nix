{ stdenv, appleDerivation }:

appleDerivation {
  dontBuild = true;

  installFlags = [ "EXPORT_DSTDIR=/include/architecture" ];

  DSTROOT = "$(out)";

  meta = with stdenv.lib; {
    maintainers = with maintainers; [ copumpkin ];
    platforms   = platforms.darwin;
    license     = licenses.apsl20;
  };
}
