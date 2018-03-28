{ stdenv, lib, fetchurl, jdk, zip, unzip, bash, writeScriptBin, coreutils, makeWrapper, which, python
, CoreServices, Foundation

# Always assume all markers valid (don't redownload dependencies).
# Also, don't clean up environment variables.
, enableNixHacks ? false
}:

stdenv.mkDerivation rec {

  version = "0.10.1";

  meta = with stdenv.lib; {
    homepage = "https://github.com/bazelbuild/bazel/";
    description = "Build tool that builds code quickly and reliably";
    license = licenses.asl20;
    maintainers = [ maintainers.philandstuff ];
    platforms = with platforms; linux ++ darwin;
  };

  name = "bazel-${version}";

  src = fetchurl {
    url = "https://github.com/bazelbuild/bazel/releases/download/${version}/bazel-${version}-dist.zip";
    sha256 = "0rz6zvkzyglf0mmc178avf52zynz487m4v0089ilsbrgv7v4i0kh";
  };

  sourceRoot = ".";

  patches = lib.optional enableNixHacks ./nix-hacks.patch;

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
  ] ++ lib.optionals stdenv.isDarwin [ CoreServices Foundation ];

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

  # Darwin-only hacks to work around Bazel calling CC without NIX_* env vars, which provide framework paths
  buildPhase = (lib.optionalString stdenv.isDarwin ''
    echo "#!${customBash}/bin/bash" >> cc.sh
    chmod +x cc.sh
    export CC=$(pwd)/cc.sh
    export CXX=$(pwd)/cxx.sh
    declare -px >> cc.sh
    cp cc.sh cxx.sh

    echo "clang \"\$@\" || clang++ \"\$@\" " >> cc.sh
    echo "export isCpp=1; export cppInclude=1" >> cxx.sh
    echo "clang++ \"\$@\"" >> cxx.sh
  '') + ''
    export TMPDIR=/tmp

    ./compile.sh
    ./output/bazel --output_user_root=/tmp/.bazel build //scripts:bash_completion \
      --spawn_strategy=standalone \
      --genrule_strategy=standalone
    cp bazel-bin/scripts/bazel-complete.bash output/
  '';

  # Build the CPP and Java examples to verify that Bazel works.
  # This is disabled on Darwin due to Bazel mangling calls to CC/LD
  doCheck = (!stdenv.isDarwin);
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
    wrapProgram "$out/bin/bazel" \
      --prefix PATH : "${lib.makeBinPath [ stdenv.cc jdk ]}" \
      --set JAVA_HOME "${jdk}"
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
