{ stdenv, pythonPackages, runCommand, curl }:

with stdenv.lib;
with pythonPackages;

let
  # Get rid of this when pants 1.3.0 is released and make 0.5 the default
  pathspec_0_3_4 = buildPythonApplication rec {
    pname   = "pathspec";
    version = "0.3.4";
    name    = "${pname}-${version}";

    src = fetchPypi {
      inherit pname version;
      sha256 = "0a37yrr2jhlg8aiynxivh2xqani7l9j725qxzrm7cm7m4rfcl1bn";
    };

    meta = {
      description = "Utility library for gitignore-style pattern matching of file paths";
      homepage = "https://github.com/cpburnz/python-path-specification";
      license = licenses.mpl20;
     maintainers = with maintainers; [ copumpkin ];
    };
  };

  pants13-version = "1.3.0rc4";

  # TODO: compile the rust native engine ourselves so we don't need to do this shit. We don't use
  # fetchurl because we don't know the URL ahead of time, even though it's deterministic. So we have
  # this downloader figure out the URL on the fly and then produce the deterministic result, so we
  # can still be a fixed-output derivation.
  pants13-native-engine-info = {
    "x86_64-darwin" = { prefix = "mac/10.11";    hash = "04kfqp4fcxj7zkyb21rgp1kdrlnmayfvakpg5xips716d7pp6vc7"; };
    "x86_64-linux"  = { prefix = "linux/x86_64"; hash = "0vgmcqxcabryxgvk4wmbclqjn56jbmsaysckgwfzhmif8pxyrfam"; };
    "i686-linux"    = { prefix = "linux/i386";   hash = "1xgma6cwvzg1d07xq6bd3j4rpzp6wn6lz82xqprr6vflyn78qaaw"; };
  }.${stdenv.system} or (throw "Unsupported system ${stdenv.system}!");

  pants13-native-engine = runCommand "pants-native-${pants13-version}" {
    buildInputs    = [ curl ];
    outputHashMode = "recursive";
    outputHashAlgo = "sha256";
    outputHash     = pants13-native-engine-info.hash;
  } ''
    native_version=$(curl -k -L https://raw.githubusercontent.com/pantsbuild/pants/release_${pants13-version}/src/python/pants/engine/subsystem/native_engine_version)
    curl -kLO "https://dl.bintray.com/pantsbuild/bin/build-support/bin/native-engine/${pants13-native-engine-info.prefix}/$native_version/native_engine.so"

    # Ugh it tries to "download" from this prefix so let's just replicate their directory structure for now...
    mkdir -p $out/bin/native-engine/${pants13-native-engine-info.prefix}/$native_version/

    # These should behave the same way in Nix land and we try not to differentiate between OS revisions...
    mkdir -p $out/bin/native-engine/mac/
    ln -s 10.11 $out/bin/native-engine/mac/10.10
    ln -s 10.11 $out/bin/native-engine/mac/10.12

    cp native_engine.so $out/bin/native-engine/${pants13-native-engine-info.prefix}/$native_version/
  '';
in {
  pants =
    pythonPackages.buildPythonPackage rec {
    pname   = "pantsbuild.pants";
    version = "1.2.1";
    name    = "${pname}-${version}";

    src = fetchPypi {
      inherit pname version;
      sha256 = "1bnzhhd2acwk7ckv56xzg2d9vxacl3k5bh13bsjxymnq3spm962w";
    };

    prePatch = ''
      sed -E -i "s/'([[:alnum:].-]+)[=><][^']*'/'\\1'/g" setup.py
    '';

    # Unnecessary, and causes some really weird behavior around .class files, which
    # this package bundles. See https://github.com/NixOS/nixpkgs/issues/22520.
    dontStrip = true;

    propagatedBuildInputs = [
      ansicolors beautifulsoup4 cffi coverage docutils fasteners futures
      isort lmdb markdown mock packaging pathspec_0_3_4 pep8 pex psutil pyflakes
      pygments pystache pytestcov pytest pywatchman requests scandir
      setproctitle setuptools six thrift wheel twitter-common-dirutil
      twitter-common-confluence twitter-common-collections
    ];

    meta = {
      description = "A build system for software projects in a variety of languages";
      homepage    = "http://www.pantsbuild.org/";
      license     = licenses.asl20;
      maintainers = with maintainers; [ copumpkin ];
      platforms   = platforms.unix;
    };
  };

  pants13-pre = buildPythonApplication rec {
    pname   = "pantsbuild.pants";
    version = pants13-version;
    name    = "${pname}-${version}";

    src = fetchPypi {
      inherit pname version;
      sha256 = "03zv3g55x056vjggwjr8lpniixcpb3kfy7xkl1bxsvjp2ih2wj6g";
    };

    prePatch = ''
      sed -E -i "s/'([[:alnum:].-]+)[=><][[:digit:]=><.,]*'/'\\1'/g" setup.py

      substituteInPlace src/pants/option/global_options.py \
        --replace "'/etc/pantsrc'" "'$out/etc/pantsrc', '/etc/pantsrc'"
    '';

    # Unnecessary, and causes some really weird behavior around .class files, which
    # this package bundles. See https://github.com/NixOS/nixpkgs/issues/22520.
    dontStrip = true;

    propagatedBuildInputs = [
      twitter-common-collections setproctitle setuptools six ansicolors
      packaging pathspec scandir twitter-common-dirutil psutil requests
      pystache pex docutils markdown pygments twitter-common-confluence
      fasteners coverage pywatchman futures cffi
    ];

    # Teach pants about where its native engine lives.
    # TODO: there's probably a better way to teach it this without having it "download"
    # from a local file: URL to its cache, but I don't know how and this seems to work.
    postFixup = ''
      mkdir -p $out/etc
      cat >$out/etc/pantsrc <<EOF
      [binaries]
      baseurls: [ 'file://${pants13-native-engine}' ]
      EOF
    '';

    meta = {
      description = "A build system for software projects in a variety of languages";
      homepage    = "http://www.pantsbuild.org/";
      license     = licenses.asl20;
      maintainers = with maintainers; [ copumpkin ];
      platforms   = platforms.unix;
    };
  };
}
