{ stdenv, runCommand }:

let
  bad-shebang = stdenv.mkDerivation {
    name         = "bad-shebang";
    unpackPhase  = ":";
    installPhase = ''
      mkdir -p $out/bin
      echo "#!/bin/sh" > $out/bin/test
      echo "echo -n hello" >> $out/bin/test
      chmod +x $out/bin/test
    '';
  };
in runCommand "patch-shebangs-test" {
  passthru = { inherit bad-shebang; };
  meta.platforms = stdenv.lib.platforms.all;
} ''
  printf "checking whether patchShebangs works properly... ">&2
  if ! grep -q '^#!/bin/sh' ${bad-shebang}/bin/test; then
    echo "yes" >&2
    touch $out
  else
    echo "no" >&2
    exit 1
  fi
''