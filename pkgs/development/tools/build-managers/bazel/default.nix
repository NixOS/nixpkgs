{ stdenv, fetchFromGitHub, buildFHSUserEnv, writeScript, jdk, zip, unzip,
  which, makeWrapper, binutils }:

let

  version = "0.3.2";

  meta = with stdenv.lib; {
    homepage = http://github.com/bazelbuild/bazel/;
    description = "Build tool that builds code quickly and reliably";
    license = licenses.asl20;
    maintainers = [ maintainers.philandstuff ];
    platforms = [ "x86_64-linux" ];
  };

  bootstrapEnv = buildFHSUserEnv {
    name = "bazel-bootstrap-env";

    targetPkgs = pkgs: [ ];

    inherit meta;
  };

  bazelBinary = stdenv.mkDerivation rec {
    name = "bazel-${version}";
  
    src = fetchFromGitHub {
      owner = "bazelbuild";
      repo = "bazel";
      rev = version;
      sha256 = "085cjz0qhm4a12jmhkjd9w3ic4a67035j01q111h387iklvgn6xg";
    };
    patches = [ ./java_stub_template.patch ];

    packagesNotFromEnv = [
        stdenv.cc stdenv.cc.cc.lib jdk which zip unzip binutils ];
    buildInputs = packagesNotFromEnv ++ [ bootstrapEnv makeWrapper ];

    buildTimeBinPath = stdenv.lib.makeBinPath packagesNotFromEnv;
    buildTimeLibPath = stdenv.lib.makeLibraryPath packagesNotFromEnv;

    runTimeBinPath = stdenv.lib.makeBinPath [ jdk stdenv.cc.cc ];
    runTimeLibPath = stdenv.lib.makeLibraryPath [ stdenv.cc.cc.lib ];

    buildWrapper = writeScript "build-wrapper.sh" ''
      #! ${stdenv.shell} -e
      export PATH="${buildTimeBinPath}:$PATH"
      export LD_LIBRARY_PATH="${buildTimeLibPath}:$LD_LIBRARY_PATH"
      ./compile.sh
    '';
  
    buildPhase = ''
      bazel-bootstrap-env ${buildWrapper}
    '';
  
    installPhase = ''
      mkdir -p $out/bin
      cp output/bazel $out/bin/
      wrapProgram $out/bin/bazel \
          --suffix PATH ":" "${runTimeBinPath}" \
          --suffix LD_LIBRARY_PATH ":" "${runTimeLibPath}"
    '';
  
    dontStrip = true;
    dontPatchELF = true;
  
    inherit meta;
  };

in bazelBinary
