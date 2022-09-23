{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, zlib
, curl
, elfutils
, python3
, libiberty
# TODO: switch back to latest versions when upstream ports
# to binutils-2.39: https://github.com/SimonKagstrom/kcov/issues/381
, libopcodes_2_38
, runCommand
, gcc
, rustc
}:

let
  self =
    stdenv.mkDerivation rec {
      pname = "kcov";
      version = "38";

      src = fetchFromGitHub {
        owner = "SimonKagstrom";
        repo = "kcov";
        rev = "v${version}";
        sha256 = "sha256-6LoIo2/yMUz8qIpwJVcA3qZjjF+8KEM1MyHuyHsQD38=";
      };

      preConfigure = "patchShebangs src/bin-to-c-source.py";
      nativeBuildInputs = [ cmake pkg-config python3 ];

      buildInputs = [ curl zlib elfutils libiberty libopcodes_2_38 ];

      strictDeps = true;

      passthru.tests = {
        works-on-c = runCommand "works-on-c" {} ''
          set -ex
          cat - > a.c <<EOF
          int main() {}
          EOF
          ${gcc}/bin/gcc a.c -o a.out
          ${self}/bin/kcov /tmp/kcov ./a.out
          test -e /tmp/kcov/index.html
          touch $out
          set +x
        '';

        works-on-rust = runCommand "works-on-rust" {} ''
          set -ex
          cat - > a.rs <<EOF
          fn main() {}
          EOF
          # Put gcc in the path so that `cc` is found
          PATH=${gcc}/bin:$PATH ${rustc}/bin/rustc a.rs -o a.out
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

        maintainers = with maintainers; [ gal_bolle ekleog ];
        platforms = platforms.linux;
      };
    };
in
self
