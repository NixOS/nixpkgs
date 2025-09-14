{
  lib,
  fetchurl,
  mkTclDerivation,
}:

mkTclDerivation {
  pname = "wapp";
  version = "0-unstable-2024-11-22";

  src = fetchurl {
    url = "https://wapp.tcl-lang.org/home/raw/3b1ce7c0234b4b2750deadc80f524ed28e835aa5e741bf3fe63b416a16a55699?at=wapp.tcl";
    hash = "sha256-0e9yTVFYj1tYGU7EiXRPw35qfDzckzz4i3RV/8TttGw=";
  };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/wapp
    cp $src $out/lib/wapp/wapp.tcl
    cat <<EOF > $out/lib/wapp/pkgIndex.tcl
    package ifneeded wapp 1.0 [list source [file join \$dir wapp.tcl]]
    EOF

    runHook postInstall
  '';

  meta = {
    homepage = "https://wapp.tcl-lang.org/home/doc/trunk/README.md";
    description = "Framework for writing web applications in Tcl";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ nat-418 ];
  };
}
