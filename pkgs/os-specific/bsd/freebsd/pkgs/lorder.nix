{ mkDerivation
, bsdSetupHook, freebsdSetupHook
}:

mkDerivation rec {
  path = "usr.bin/lorder";
  noCC = true;
  dontBuild = true;
  installPhase = ''
    mkdir -p "$out/bin" "$man/share/man"
    mv "lorder.sh" "$out/bin/lorder"
    chmod +x "$out/bin/lorder"
    mv "lorder.1" "$man/share/man"
  '';
  nativeBuildInputs = [
    bsdSetupHook freebsdSetupHook
  ];
  buildInputs = [];
  outputs = [ "out" "man" ];
}
