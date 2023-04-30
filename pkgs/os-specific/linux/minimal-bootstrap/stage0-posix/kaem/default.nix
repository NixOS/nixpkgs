{ lib
, derivationWithMeta
, kaem-unwrapped
, mescc-tools-extra
, version
}:

# Once mescc-tools-extra is available we can install kaem at /bin/kaem
# to make it findable in environments
derivationWithMeta {
  inherit version kaem-unwrapped;
  pname = "kaem";
  builder = kaem-unwrapped;
  args = [
    "--verbose"
    "--strict"
    "--file"
    (builtins.toFile "kaem-wrapper.kaem" ''
      mkdir -p ''${out}/bin
      cp ''${kaem-unwrapped} ''${out}/bin/kaem
      chmod 555 ''${out}/bin/kaem
    '')
  ];
  PATH = lib.makeBinPath [ mescc-tools-extra ];

  meta = with lib; {
    description = "Minimal build tool for running scripts on systems that lack any shell";
    homepage = "https://github.com/oriansj/mescc-tools";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ emilytrau ];
    platforms = [ "i686-linux" ];
  };
}
