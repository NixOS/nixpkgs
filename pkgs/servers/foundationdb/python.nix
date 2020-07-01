{ buildPythonPackage, lib, foundationdb }:

buildPythonPackage {
  pname = "foundationdb";
  version = foundationdb.version;

  src = foundationdb.pythonsrc;
  unpackCmd = "tar xf $curSrc";

  patchPhase = ''
    substituteInPlace ./fdb/impl.py \
      --replace libfdb_c.so "${foundationdb.lib}/lib/libfdb_c.so"
  '';

  doCheck = false;

  meta = with lib; {
    description = "Python bindings for FoundationDB";
    homepage    = "https://www.foundationdb.org";
    license     = with licenses; [ asl20 ];
    maintainers = with maintainers; [ thoughtpolice ];
  };
}

