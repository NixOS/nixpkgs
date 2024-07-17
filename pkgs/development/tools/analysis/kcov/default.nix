{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  zlib,
  curl,
  elfutils,
  python3,
  libiberty,
  libopcodes,
  runCommandCC,
  rustc,
}:

let
  self = stdenv.mkDerivation rec {
    pname = "kcov";
    version = "42";

    src = fetchFromGitHub {
      owner = "SimonKagstrom";
      repo = "kcov";
      rev = "v${version}";
      sha256 = "sha256-8/182RjuNuyFzSyCgyyximGaveDyhStwIQg29S5U/pI=";
    };

    preConfigure = "patchShebangs src/bin-to-c-source.py";
    nativeBuildInputs = [
      cmake
      pkg-config
      python3
    ];

    buildInputs = [
      curl
      zlib
      elfutils
      libiberty
      libopcodes
    ];

    strictDeps = true;

    passthru.tests = {
      works-on-c = runCommandCC "works-on-c" { } ''
        set -ex
        cat - > a.c <<EOF
        int main() {}
        EOF
        $CC a.c -o a.out
        ${self}/bin/kcov /tmp/kcov ./a.out
        test -e /tmp/kcov/index.html
        touch $out
        set +x
      '';

      works-on-rust = runCommandCC "works-on-rust" { nativeBuildInputs = [ rustc ]; } ''
        set -ex
        cat - > a.rs <<EOF
        fn main() {}
        EOF
        # Put gcc in the path so that `cc` is found
        rustc a.rs -o a.out
        ${self}/bin/kcov /tmp/kcov ./a.out
        test -e /tmp/kcov/index.html
        touch $out
        set +x
      '';
    };

    meta = with lib; {
      description = "Code coverage tester for compiled programs, Python scripts and shell scripts";

      longDescription = ''
        Kcov is a code coverage tester for compiled programs, Python
        scripts and shell scripts. It allows collecting code coverage
        information from executables without special command-line
        arguments, and continuosly produces output from long-running
        applications.
      '';

      homepage = "http://simonkagstrom.github.io/kcov/index.html";
      license = licenses.gpl2;
      changelog = "https://github.com/SimonKagstrom/kcov/blob/master/ChangeLog";

      maintainers = with maintainers; [
        gal_bolle
        ekleog
      ];
      platforms = platforms.linux;
    };
  };
in
self
