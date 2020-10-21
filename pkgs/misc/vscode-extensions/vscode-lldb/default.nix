{ lib, stdenv, vscode-utils, fetchFromGitHub, rustPlatform, makeWrapper, jq
, nodePackages, cmake, nodejs, unzip, python3, lldb, breakpointHook
, setDefaultLldbPath ? true
}:
assert lib.versionAtLeast python3.version "3.5";
let
  publisher = "vadimcn";
  name = "vscode-lldb";
  version = "1.5.3";

  dylibExt = stdenv.hostPlatform.extensions.sharedLibrary;

  src = fetchFromGitHub {
    owner = "vadimcn";
    repo = "vscode-lldb";
    rev = "v${version}";
    sha256 = "1139945j3z0fxc3nlyvd81k0ypymqsj051idrbgbibwshpi86y93";
    fetchSubmodules = true;
  };

  adapter = rustPlatform.buildRustPackage {
    pname = "${name}-adapter";
    inherit version src;

    cargoSha256 = "0jl4msf2jcjxddwqkx8fr0c35wg4vwvg5c19mihri1v34i09zc5r";

    # It will pollute the build environment of `buildRustPackage`.
    cargoPatches = [ ./reset-cargo-config.patch ];

    nativeBuildInputs = [ makeWrapper ];

    buildAndTestSubdir = "adapter";

    # Hack: Need a nightly compiler.
    RUSTC_BOOTSTRAP = 1;

    # `adapter` expects a special hierarchy to resolve everything well.
    postInstall = ''
      mkdir -p $out/adapter
      mv -t $out/adapter \
        $out/bin/* \
        $out/lib/* \
        ./adapter/*.py \
        ./formatters/*.py
      rmdir $out/{bin,lib}
    '';

    postFixup = ''
      wrapProgram $out/adapter/codelldb \
        --prefix PATH : "${python3}/bin" \
        --prefix LD_LIBRARY_PATH : "${python3}/lib"
    '';
  };

  build-deps = nodePackages."vscode-lldb-build-deps-../../misc/vscode-extensions/vscode-lldb/build-deps";

  vsix = stdenv.mkDerivation {
    name = "${name}-${version}-vsix";
    inherit src;

    # Only build the extension. We handle `adapter` and `lldb` with nix.
    patches = [ ./cmake-build-extension-only.patch ];

    nativeBuildInputs = [ cmake nodejs unzip breakpointHook ];

    postConfigure = ''
      cp -r ${build-deps}/lib/node_modules/vscode-lldb/{node_modules,package-lock.json} .
    '';

    makeFlags = [ "vsix_bootstrap" ];

    installPhase = ''
      unzip ./codelldb-bootstrap.vsix 'extension/*' -d ./vsix-extracted
      mv vsix-extracted/extension $out

      ln -s ${adapter}/adapter $out
      # Mark that adapter and lldb are installed.
      touch $out/platform.ok
    '';

    dontStrip = true;
    dontPatchELF = true;
  };

in vscode-utils.buildVscodeExtension {
  inherit name;
  src = vsix;

  nativeBuildInputs = lib.optional setDefaultLldbPath jq;
  postUnpack = lib.optionalString setDefaultLldbPath ''
    jq '.contributes.configuration.properties."lldb.library".default = $s' \
      --arg s "${lldb}/lib/liblldb.so" \
      $sourceRoot/package.json >$sourceRoot/package.json.new
    mv $sourceRoot/package.json.new $sourceRoot/package.json
  '';

  vscodeExtUniqueId = "${publisher}.${name}";

  meta = with lib; {
    description = "A native debugger extension for VSCode based on LLDB";
    homepage = "https://github.com/vadimcn/vscode-lldb";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ oxalica ];
    platforms = platforms.all;
  };
}
