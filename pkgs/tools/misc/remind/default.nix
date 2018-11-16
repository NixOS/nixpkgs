{stdenv, fetchurl, tk, tcllib, makeWrapper
, tkremind ? true
} :

assert tkremind -> tk != null;
assert tkremind -> tcllib != null;
assert tkremind -> makeWrapper != null;

stdenv.mkDerivation rec {
  name = "remind-3.1.15";
  src = fetchurl {
    url = https://www.roaringpenguin.com/files/download/remind-03.01.15.tar.gz;
    sha256 = "1hcfcxz5fjzl7606prlb7dgls5kr8z3wb51h48s6qm8ang0b9nla";
  };

  tclLibraries = if tkremind then [ tcllib tk ] else [];
  tclLibPaths = stdenv.lib.concatStringsSep " "
    (map (p: "${p}/lib/${p.libPrefix}") tclLibraries);

  buildInputs = if tkremind then [ makeWrapper ] else [];
  propagatedBuildInputs = tclLibraries;

  postPatch = if tkremind then ''
    substituteInPlace scripts/tkremind --replace "exec wish" "exec ${tk}/bin/wish"
  '' else "";

  postInstall = if tkremind then ''
    wrapProgram $out/bin/tkremind --set TCLLIBPATH "${tclLibPaths}"
  '' else "";

  meta = {
    homepage = http://www.roaringpenguin.com/products/remind;
    description = "Sophisticated calendar and alarm program for the console";
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [raskin kovirobi];
    platforms = with stdenv.lib.platforms; linux;
  };
}
