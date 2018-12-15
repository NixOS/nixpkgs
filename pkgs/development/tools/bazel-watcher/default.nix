{ buildBazelPackage
, cacert
, fetchFromGitHub
, fetchpatch
, git
, go
, stdenv
}:

buildBazelPackage rec {
  name = "bazel-watcher-${version}";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "bazelbuild";
    repo = "bazel-watcher";
    rev = "v${version}";
    sha256 = "1sis723hwax4dg0c28x20yj0hjli66q1ykcvjirgy57znz4iwlq9";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/bazelbuild/bazel-watcher/commit/4d5928eee3dd5843a1b55136d914b78fef7f25d0.patch";
      sha256 = "0gxzcdqgifrmvznfy0p5nd11b39n2pwxcvpmhc6hxf85mwlxz7dg";
    })

    ./update-gazelle-fix-ssl.patch
  ];

  nativeBuildInputs = [ go git ];

  bazelTarget = "//ibazel";

  fetchAttrs = {
    preBuild = ''
      patchShebangs .

      # tell rules_go to use the Go binary found in the PATH
      sed -e 's:go_register_toolchains():go_register_toolchains(go_version = "host"):g' -i WORKSPACE

      # tell rules_go to invoke GIT with custom CAINFO path
      export GIT_SSL_CAINFO="${cacert}/etc/ssl/certs/ca-bundle.crt"
    '';

    preInstall = ''
      # Remove the go_sdk (it's just a copy of the go derivation) and all
      # references to it from the marker files. Bazel does not need to download
      # this sdk because we have patched the WORKSPACE file to point to the one
      # currently present in PATH. Without removing the go_sdk from the marker
      # file, the hash of it will change anytime the Go derivation changes and
      # that would lead to impurities in the marker files which would result in
      # a different sha256 for the fetch phase.
      rm -rf $bazelOut/external/{go_sdk,\@go_sdk.marker}
      sed -e '/^FILE:@go_sdk.*/d' -i $bazelOut/external/\@*.marker
    '';

    sha256 = "1iyjvibvlwg980p7nizr6x5v31dyp4a344f0xn839x393583k59d";
  };

  buildAttrs = {
    preBuild = ''
      patchShebangs .

      # tell rules_go to use the Go binary found in the PATH
      sed -e 's:go_register_toolchains():go_register_toolchains(go_version = "host"):g' -i WORKSPACE
    '';

    installPhase = ''
      install -Dm755 bazel-bin/ibazel/*_pure_stripped/ibazel $out/bin/ibazel
    '';
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/bazelbuild/bazel-watcher;
    description = "Tools for building Bazel targets when source files change.";
    license = licenses.asl20;
    maintainers = with maintainers; [ kalbasit ];
    platforms = platforms.all;
  };
}
