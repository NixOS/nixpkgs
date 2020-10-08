{stdenv, fetchurl, tk, tcllib, makeWrapper
, tkremind ? true
} :

assert tkremind -> tk != null;
assert tkremind -> tcllib != null;
assert tkremind -> makeWrapper != null;

let
  inherit (stdenv.lib) optional optionalString;
  tclLibraries = stdenv.lib.optionals tkremind [ tcllib tk ];
  tclLibPaths = stdenv.lib.concatStringsSep " "
    (map (p: "${p}/lib/${p.libPrefix}") tclLibraries);
  tkremindPatch = optionalString tkremind ''
    substituteInPlace scripts/tkremind --replace "exec wish" "exec ${tk}/bin/wish"
  '';
in stdenv.mkDerivation rec {
  pname = "remind";
  version = "03.03.01";

  src = fetchurl {
    url = "https://dianne.skoll.ca/projects/remind/download/remind-${version}.tar.gz";
    sha256 = "0y4l960529sl3sn4r4g36qpy3jk5h1x4algjy7an7sfiqb8n98fi";
  };

  nativeBuildInputs = optional tkremind makeWrapper;
  propagatedBuildInputs = tclLibraries;

  postPatch = ''
    substituteInPlace ./configure \
      --replace "sleep 1" "true"
    substituteInPlace ./src/init.c \
      --replace "rkrphgvba(0);" "" \
      --replace "rkrphgvba(1);" ""
    ${tkremindPatch}
  '';

  postInstall = optionalString tkremind ''
    wrapProgram $out/bin/tkremind --set TCLLIBPATH "${tclLibPaths}"
  '';

  meta = {
    homepage = "https://dianne.skoll.ca/projects/remind/";
    description = "Sophisticated calendar and alarm program for the console";
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [raskin kovirobi];
    platforms = with stdenv.lib.platforms; unix;
  };
}
