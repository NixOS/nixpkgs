{ lib, fetchFromGitHub, python3 }:

let
  make-scons = (import ./make-scons.nix) {
    inherit lib fetchFromGitHub python3;
  };
in
{
  scons_3_1_2 = make-scons {
    version = "3.1.2";
    hash = "sha256-C3U4N7+9vplzoJoevQe5Zeuz0TDmB6/miMwBJLzA3WA=";

    preConfigure = ''
      python bootstrap.py
      cd build/scons
    '';
  };

  scons_4_1_0 = make-scons {
    version = "4.1.0";
    hash = "sha256-ldus/9ghqAMB7A+NrHiCQm7saCdIpqzufGCLxWRhYKU=";

    patches = [
      ./env.patch
    ];

    postPatch = ''
      substituteInPlace setup.cfg \
        --replace "build/dist" "dist"
    '';

    preConfigure = ''
      python scripts/scons.py
    '';

    postInstall = ''
      mkdir -pv "$man/share/man/man1"
      mv -v "$out/"*.1 "$man/share/man/man1/"
    '';
  };

  scons_4_5_2 = make-scons {
    version = "4.5.2";
    hash = "sha256-vxJsz24jDsPcttwPXq9+ztc/N7W4Gkydgykk/FLgZLo=";

    patches = [
      ./env.patch
    ];

    postPatch = ''
      substituteInPlace setup.cfg \
        --replace "build/dist" "dist" \
        --replace "build/doc/man/" ""
    '';

    preConfigure = ''
      python scripts/scons.py
    '';

    postInstall = ''
      mkdir -p "$man/share/man/man1"
      mv "$out/"*.1 "$man/share/man/man1/"
    '';
  };
}
