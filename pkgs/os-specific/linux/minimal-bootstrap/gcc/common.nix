{
  lib,
  bash,
  fetchurl,
  gnupatch,
  gnutar,
  xz,
}:
let
  version = "16.1.0";
  src = fetchurl {
    url = "mirror://gnu/gcc/gcc-${version}/gcc-${version}.tar.xz";
    hash = "sha256-UO+02Uwzl6/zsNYaWr10i03THZ0/Kre+BbFx02pRD3k=";
  };
  patches = [
    (fetchurl {
      name = "regular-libdir-includedir.patch";
      url = "https://inbox.sourceware.org/gcc-patches/20250717174911.1536129-1-git@JohnEricson.me/raw";
      hash = "sha256-Cn7rvg1FI7H/26GzSe4pv5VW/gvwbwGqivAqEeawkwk=";
    })
    ./configure-skip-target-libs-hooks.patch
  ];
in
{
  inherit src version;
  monorepoSrc =
    bash.runCommand "gcc-${version}-src"
      {
        nativeBuildInputs = [
          gnutar
          gnupatch
          xz
        ];
      }
      ''
        # Unpack
        mkdir $out/
        tar xf ${src} --directory=$out/ --strip-components=1

        # Patch
        cd $out/
        ${lib.concatMapStringsSep "\n" (f: "patch -Np1 -i ${f}") patches}

        # Ensure gengtype-lex is not rebuilt from .y; we have no yacc at this stage.
        touch gcc/gengtype-lex.cc
      '';
  meta = {
    description = "GNU Compiler Collection, version ${version}";
    homepage = "https://gcc.gnu.org";
    license = lib.licenses.gpl3Plus;
    teams = [ lib.teams.minimal-bootstrap ];
    platforms = lib.platforms.unix;
  };
}
