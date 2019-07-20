{ stdenv, lib, fetchurl, jdk, zip, unzip, bash, makeWrapper, which, coreutils
# Always assume all markers valid (don't redownload dependencies).
# Also, don't clean up environment variables.
, enableNixHacks ? false
}:

stdenv.mkDerivation rec {

  version = "0.4.5";

  meta = with stdenv.lib; {
    homepage = https://github.com/bazelbuild/bazel/;
    description = "Build tool that builds code quickly and reliably";
    license = licenses.asl20;
    maintainers = with maintainers; [ cstrahan philandstuff ];
    platforms = platforms.linux;
    broken = true; # 2018-08-07
  };

  name = "bazel-${version}";

  src = fetchurl {
    url = "https://github.com/bazelbuild/bazel/releases/download/${version}/bazel-${version}-dist.zip";
    sha256 = "0asmq3kxnl4326zhgh13mvcrc8jvmiswjj4ymrq0943q4vj7nwrb";
  };

  preUnpack = ''
    mkdir bazel
    cd bazel
  '';
  sourceRoot = ".";

  patches = lib.optional enableNixHacks ./nix-hacks-0.4.patch;

  postPatch = ''
    for f in $(grep -l -r '/bin/bash'); do
      substituteInPlace "$f" --replace '/bin/bash' '${bash}/bin/bash'
    done
    for f in $(grep -l -r '/usr/bin/env'); do
      substituteInPlace "$f" --replace '/usr/bin/env' '${coreutils}/bin/env'
    done
  '' + lib.optionalString stdenv.isDarwin ''
    sed -i 's,/usr/bin/xcrun clang,clang,g' \
      scripts/bootstrap/compile.sh \
      src/tools/xcode/realpath/BUILD \
      src/tools/xcode/stdredirect/BUILD \
      src/tools/xcode/xcrunwrapper/xcrunwrapper.sh
    sed -i 's,/usr/bin/xcrun "''${TOOLNAME}","''${TOOLNAME}",g' \
      src/tools/xcode/xcrunwrapper/xcrunwrapper.sh
    sed -i 's/"xcrun", "clang"/"clang"/g' tools/osx/xcode_configure.bzl
  '';

  buildInputs = [
    jdk
    zip
    unzip
    makeWrapper
    which
  ];

  # These must be propagated since the dependency is hidden in a compressed
  # archive.

  propagatedBuildInputs = [
    bash
  ];

  buildPhase = ''
    export TMPDIR=/tmp/.bazel-$UID
    ./compile.sh
    ./output/bazel --output_user_root=$TMPDIR/.bazel build //scripts:bash_completion \
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
    wrapProgram "$out/bin/bazel" --prefix PATH : "${stdenv.cc}/bin:${jdk}/bin"
    mkdir -p $out/share/bash-completion/completions $out/share/zsh/site-functions
    mv output/bazel-complete.bash $out/share/bash-completion/completions/
    cp scripts/zsh_completion/_bazel $out/share/zsh/site-functions/
  '';

  dontStrip = true;
  dontPatchELF = true;
}
