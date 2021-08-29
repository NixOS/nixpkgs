{ lib, stdenv, fetchFromGitHub, rustPlatform, makeWrapper, jq, callPackage
, nodePackages, cmake, nodejs, unzip, python3
}:
assert lib.versionAtLeast python3.version "3.5";
let
  publisher = "vadimcn";
  pname = "vscode-lldb";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "vadimcn";
    repo = "vscode-lldb";
    rev = "v${version}";
    sha256 = "sha256-mi+AeHg9zO0vjF0OZCufPkliInqxTvDGV350wqAwe90=";
    fetchSubmodules = true;
  };

  lldb = callPackage ./lldb.nix {};

  adapter = rustPlatform.buildRustPackage {
    pname = "${pname}-adapter";
    inherit version src;

    # It will pollute the build environment of `buildRustPackage`.
    cargoPatches = [ ./reset-cargo-config.patch ];

    cargoSha256 = "sha256-vcL/nSGhyE0INQVWxEIpYwXmnOl1soBn+mymZr1FaSM=";

    nativeBuildInputs = [ makeWrapper ];

    buildAndTestSubdir = "adapter";

    cargoFlags = [
      "--lib"
      "--bin=codelldb"
      "--features=weak-linkage"
    ];

    # Tests are linked to liblldb but it is not available here.
    doCheck = false;
  };

  nodeDeps = nodePackages."vscode-lldb-build-deps-../../misc/vscode-extensions/vscode-lldb/build-deps";

in stdenv.mkDerivation rec {
  name = "vscode-extension-${pname}";
  inherit src;
  vscodeExtUniqueId = "${publisher}.${pname}";
  installPrefix = "share/vscode/extensions/${vscodeExtUniqueId}";

  nativeBuildInputs = [ cmake nodejs unzip makeWrapper ];

  patches = [ ./cmake-build-extension-only.patch ];

  postConfigure = ''
    cp -r ${nodeDeps}/lib/node_modules/vscode-lldb/{node_modules,package-lock.json} .
  '';

  cmakeFlags = [
    # Do not append timestamp to version.
    "-DVERSION_SUFFIX="
  ];
  makeFlags = [ "vsix_bootstrap" ];

  installPhase = ''
    ext=$out/$installPrefix
    runHook preInstall

    unzip ./codelldb-bootstrap.vsix 'extension/*' -d ./vsix-extracted

    mkdir -p $ext/{adapter,formatters}
    mv -t $ext vsix-extracted/extension/*
    cp -t $ext/adapter ${adapter}/{bin,lib}/* ../adapter/*.py
    cp -t $ext/formatters ../formatters/*.py
    ln -s ${lldb} $ext/lldb
    # Mark that all components are installed.
    touch $ext/platform.ok

    runHook postInstall
  '';

  # `adapter` will find python binary and libraries at runtime.
  fixupPhase = ''
    wrapProgram $out/$installPrefix/adapter/codelldb \
      --prefix PATH : "${python3}/bin" \
      --prefix LD_LIBRARY_PATH : "${python3}/lib"
  '';

  passthru = {
    inherit lldb adapter;
  };

  meta = with lib; {
    description = "A native debugger extension for VSCode based on LLDB";
    homepage = "https://github.com/vadimcn/vscode-lldb";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ oxalica ];
    platforms = platforms.all;
    broken = stdenv.isDarwin; # Build failed on x86_64-darwin currently.
  };
}
