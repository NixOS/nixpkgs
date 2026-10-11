{
  lib,
  mkTclDerivation,
  sqawk,
}:

mkTclDerivation {
  pname = "tabulate";
  version = sqawk.version;

  src = sqawk.src;

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 lib/tabulate.tcl $out/lib/tabulate/tabulate.tcl
    cat > $out/lib/tabulate/pkgIndex.tcl <<EOF
    package ifneeded tabulate ${sqawk.version} {
      source $out/lib/tabulate/tabulate.tcl
      package provide tabulate ${sqawk.version}
    }
    EOF
    mkdir $out/bin
    ln -s $out/lib/tabulate/tabulate.tcl $out/bin/tabulate.tcl
    runHook postInstall
  '';

  tclRequiresCheck = [ "tabulate" ];

  meta = {
    description = "Convert standard input or Tcl lists into pretty-printed tables";
    homepage = "https://wiki.tcl-lang.org/page/tabulate";
    license = lib.licenses.mit;
    mainProgram = "tabulate.tcl";
    maintainers = with lib.maintainers; [ fgaz ];
    platforms = lib.platforms.all;
  };
}
