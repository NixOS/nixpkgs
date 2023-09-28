{ lib
, buildPlatform
, hostPlatform
, fetchurl
, bash
, gcc
, binutils
, gnumake
, gnugrep
, gnused
, gnutar
, gzip
}:
let
  inherit (import ./common.nix { inherit lib; }) pname meta;
  version = "1.2.4";

  src = fetchurl {
    url = "https://musl.libc.org/releases/musl-${version}.tar.gz";
    hash = "sha256-ejXq4z1TcqfA2hGI3nmHJvaIJVE7euPr6XqqpSEU8Dk=";
  };
in
bash.runCommand "${pname}-${version}" {
  inherit pname version meta;

  nativeBuildInputs = [
    gcc
    binutils
    gnumake
    gnused
    gnugrep
    gnutar
    gzip
  ];

  passthru.tests.hello-world = result:
    bash.runCommand "${pname}-simple-program-${version}" {
        nativeBuildInputs = [ gcc binutils ];
      } ''
        cat <<EOF >> test.c
        #include <stdio.h>
        int main() {
          printf("Hello World!\n");
          return 0;
        }
        EOF
        gcc -static -B${result}/lib -I${result}/include -o test test.c
        ./test
        mkdir $out
      '';
} ''
  # Unpack
  tar xzf ${src}
  cd musl-${version}

  # Patch
  # https://github.com/ZilchOS/bootstrap-from-tcc/blob/2e0c68c36b3437386f786d619bc9a16177f2e149/using-nix/2a3-intermediate-musl.nix
  sed -i 's|/bin/sh|${bash}/bin/bash|' \
    tools/*.sh
  # patch popen/system to search in PATH instead of hardcoding /bin/sh
  sed -i 's|posix_spawn(&pid, "/bin/sh",|posix_spawnp(\&pid, "sh",|' \
    src/stdio/popen.c src/process/system.c
  sed -i 's|execl("/bin/sh", "sh", "-c",|execlp("sh", "-c",|'\
    src/misc/wordexp.c

  # Configure
  bash ./configure \
    --prefix=$out \
    --build=${buildPlatform.config} \
    --host=${hostPlatform.config}

  # Build
  make

  # Install
  make install
''
