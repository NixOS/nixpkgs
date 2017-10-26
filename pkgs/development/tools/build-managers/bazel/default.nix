{ stdenv, lib, fetchurl, jdk, zip, unzip, bash, writeScriptBin, coreutils, makeWrapper, which, python }:

stdenv.mkDerivation rec {

  version = "0.6.1";

  meta = with stdenv.lib; {
    homepage = "https://github.com/bazelbuild/bazel/";
    description = "Build tool that builds code quickly and reliably";
    license = licenses.asl20;
    maintainers = [ maintainers.philandstuff ];
    platforms = platforms.linux;
  };

  name = "bazel-${version}";

  src = fetchurl {
    url = "https://github.com/bazelbuild/bazel/releases/download/${version}/bazel-${version}-dist.zip";
    sha256 = "19rb1lh6v2gi8xlxhdmhydp16i1bgmvb510i053rfy0jlmh1znns";
  };

  sourceRoot = ".";

  # Bazel expects several utils to be available in Bash even without PATH. Hence this hack.

  customBash = writeScriptBin "bash" ''
    #!${stdenv.shell}
    PATH="$PATH:${lib.makeBinPath [ coreutils ]}" exec ${bash}/bin/bash "$@"
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
  ];

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

  dontStrip = true;
  dontPatchELF = true;
}
