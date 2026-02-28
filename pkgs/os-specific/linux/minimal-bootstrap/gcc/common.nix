{
  lib,
  bash,
  fetchurl,
  gnutar,
  xz,
}:
let
  version = "15.2.0";
  src = fetchurl {
    url = "mirror://gnu/gcc/gcc-${version}/gcc-${version}.tar.xz";
    hash = "sha256-Q4/ZloJrDIJIWinaA6ctcdbjVBqD7HAt9Ccfb+Al0k4=";
  };
in
{
  inherit src version;
  monorepoSrc =
    bash.runCommand "gcc-${version}-src"
      {
        nativeBuildInputs = [
          gnutar
          xz
        ];
      }
      ''
        mkdir $out/
        tar xf ${src} --directory=$out/ --strip-components=1
      '';
  meta = {
    description = "GNU Compiler Collection, version ${version}";
    homepage = "https://gcc.gnu.org";
    license = lib.licenses.gpl3Plus;
    teams = [ lib.teams.minimal-bootstrap ];
    platforms = lib.platforms.unix;
  };
}
