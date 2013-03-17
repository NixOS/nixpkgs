{ stdenv, makeWrapper, requireFile, patchelf, rpm, cpio, libaio }:

assert stdenv.system == "x86_64-linux";

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "oracle-xe-${version}";
  version = "11.2.0";

  src = requireFile {
    name = "${name}-1.0.x86_64.rpm";
    sha256 = "0s2jj2xn56v5ys6hxb7l7045hw9c1mm1lhj4p2fvqbs02kqchab6";

    url = "http://www.oracle.com/technetwork/"
        + "products/express-edition/downloads/";
  };

  buildInputs = [ makeWrapper ];

  unpackCmd = ''
    (mkdir -p "${name}" && cd "${name}" &&
      ${rpm}/bin/rpm2cpio "$curSrc" | ${cpio}/bin/cpio -id)
  '';

  buildPhase = let
    libs = makeLibraryPath [ libaio ];
  in ''
    basedir="u01/app/oracle/product/${version}/xe"
    cat > "$basedir/network/admin/listener.ora" <<SQL
    # listener.ora Network Configuration File:

    SID_LIST_LISTENER =
      (SID_LIST =
        (SID_DESC =
          (SID_NAME = PLSExtProc)
          (ORACLE_HOME = ''${out}/libexec/oracle)
          (PROGRAM = extproc)
        )
      )

    LISTENER =
      (DESCRIPTION_LIST =
        (DESCRIPTION =
          (ADDRESS = (PROTOCOL = IPC)(KEY = EXTPROC_FOR_XE))
          (ADDRESS = (PROTOCOL = TCP)(HOST = %hostname%)(PORT = %port%))
        )
      )

    DEFAULT_SERVICE_LISTENER = (XE)
    SQL

    find u01 \
      \( -name '*.sh' \
      -o -path "$basedir/bin/*" \
      \) -print -exec "${patchelf}/bin/patchelf" \
           --interpreter "$(cat "$NIX_GCC/nix-support/dynamic-linker")" \
           --set-rpath "${libs}:$out/libexec/oracle/lib" \
           --force-rpath '{}' \;
  '';

  dontStrip = true;
  dontPatchELF = true;

  installPhase = ''
    mkdir -p "$out/libexec"
    cp -r "u01/app/oracle/product/${version}/xe" "$out/libexec/oracle"

    for i in "$out/libexec/oracle/bin"/*; do
      makeWrapper "$i" "$out/bin/''${i##*/}" \
        --set ORACLE_HOME "$out/libexec/oracle" \
        --set ORACLE_SID XE \
        --set NLS_LANG '$("'"$out"'/libexec/oracle/bin/nls_lang.sh")' \
        --prefix PATH : "$out/libexec/oracle/bin"
    done
  '';

  meta = {
    description = "Oracle Database Express Edition";
    homepage = "http://www.oracle.com/technetwork/products/express-edition/";
    license = licenses.proprietary;
  };
}
