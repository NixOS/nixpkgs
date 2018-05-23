{ stdenv, lib, fetchurl, jdk, zip, unzip, bash, writeCBin, coreutils, makeWrapper, which, python
# Always assume all markers valid (don't redownload dependencies).
# Also, don't clean up environment variables.
, enableNixHacks ? false
# Apple dependencies
, libcxx, CoreFoundation, CoreServices, Foundation
}:

stdenv.mkDerivation rec {

  version = "0.12.0";

  meta = with stdenv.lib; {
    homepage = "https://github.com/bazelbuild/bazel/";
    description = "Build tool that builds code quickly and reliably";
    license = licenses.asl20;
    maintainers = [ maintainers.philandstuff ];
    platforms = platforms.linux ++ platforms.darwin;
  };

  name = "bazel-${version}";

  src = fetchurl {
    url = "https://github.com/bazelbuild/bazel/releases/download/${version}/bazel-${version}-dist.zip";
    sha256 = "3b3e7dc76d145046fdc78db7cac9a82bc8939d3b291e53a7ce85315feb827754";
  };

  sourceRoot = ".";

  patches = lib.optional enableNixHacks ./nix-hacks.patch;

  # Bazel expects several utils to be available in Bash even without PATH. Hence this hack.

  customBash = writeCBin "bash" ''
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include <unistd.h>

    extern char **environ;

    int main(int argc, char *argv[]) {
      printf("environ: %s\n", environ[0]);
      char *path = getenv("PATH");
      char *pathToAppend = "${lib.makeBinPath [ coreutils ]}";
      char *newPath;
      if (path != NULL) {
        int length = strlen(path) + 1 + strlen(pathToAppend) + 1;
        newPath = malloc(length * sizeof(char));
        snprintf(newPath, length, "%s:%s", path, pathToAppend);
      } else {
        newPath = pathToAppend;
      }
      setenv("PATH", newPath, 1);
      execve("${bash}/bin/bash", argv, environ);
      return 0;
    }
  '';

  postPatch = ''
    find src/main/java/com/google/devtools -type f -print0 | while IFS="" read -r -d "" path; do
      substituteInPlace "$path" \
        --replace /bin/bash ${customBash}/bin/bash \
        --replace /usr/bin/env ${coreutils}/bin/env
    done
    patchShebangs .
  '';

  buildInputs = [
    jdk
  ];

  nativeBuildInputs = [
    zip
    python
    unzip
    makeWrapper
    which
    customBash
  ] ++ lib.optionals (stdenv.isDarwin) [ libcxx CoreFoundation CoreServices Foundation ];

  # If TMPDIR is in the unpack dir we run afoul of blaze's infinite symlink
  # detector (see com.google.devtools.build.lib.skyframe.FileFunction).
  # Change this to $(mktemp -d) as soon as we figure out why.

  buildPhase = ''
    export TMPDIR=/tmp
    ./compile.sh
    ./output/bazel --output_user_root=/tmp/.bazel build //scripts:bash_completion \
      --spawn_strategy=standalone \
      --genrule_strategy=standalone
    cp bazel-bin/scripts/bazel-complete.bash output/
  '';

  # Build the CPP and Java examples to verify that Bazel works.

  doCheck = true;
  checkPhase = ''
    export TEST_TMPDIR=$(pwd)
    ./output/bazel test --test_output=errors \
        examples/cpp:hello-success_test \
        examples/java-native/src/test/java/com/example/myproject:hello
  '';

  # Bazel expects gcc and java to be in the path.
  installPhase = ''
    mkdir -p $out/bin
    mv output/bazel $out/bin
    wrapProgram "$out/bin/bazel" --prefix PATH : "${lib.makeBinPath [ stdenv.cc jdk ]}"
    mkdir -p $out/share/bash-completion/completions $out/share/zsh/site-functions
    mv output/bazel-complete.bash $out/share/bash-completion/completions/
    cp scripts/zsh_completion/_bazel $out/share/zsh/site-functions/
  '';

  # Save paths to hardcoded dependencies so Nix can detect them.
  postFixup = ''
    mkdir -p $out/nix-support
    echo "${customBash} ${coreutils}" > $out/nix-support/depends
  '';

  dontStrip = true;
  dontPatchELF = true;
}
