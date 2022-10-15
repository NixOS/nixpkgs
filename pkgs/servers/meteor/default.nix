{ stdenv, lib, fetchurl, zlib, patchelf, runtimeShell }:

let
  version = "2.7.3";

  inherit (stdenv.hostPlatform) system;

  srcs = {
    x86_64-linux = fetchurl {
      url = "https://static-meteor.netdna-ssl.com/packages-bootstrap/${version}/meteor-bootstrap-os.linux.x86_64.tar.gz";
      sha256 = "sha256-ovsE7jUJIKf96WEoITXECUlPo+o1tEKvHzCc7Xgj614=";
    };
    x86_64-darwin = fetchurl {
      url = "https://static-meteor.netdna-ssl.com/packages-bootstrap/${version}/meteor-bootstrap-os.osx.x86_64.tar.gz";
      sha256 = "11206dbda50a680fdab7044def7ea68ea8f4a9bca948ca56df91fe1392b2ac16";
    };
  };
in

stdenv.mkDerivation {
  inherit version;
  pname = "meteor";
  src = srcs.${system};

  #dontStrip = true;

  sourceRoot = ".meteor";

  installPhase = ''
    mkdir $out

    cp -r packages $out
    chmod -R +w $out/packages

    cp -r package-metadata $out

    devBundle=$(find $out/packages/meteor-tool -name dev_bundle)
    ln -s $devBundle $out/dev_bundle

    toolsDir=$(dirname $(find $out/packages -print | grep "meteor-tool/.*/tools/index.js$"))
    ln -s $toolsDir $out/tools

    # Meteor needs an initial package-metadata in $HOME/.meteor,
    # otherwise it fails spectacularly.
    mkdir -p $out/bin
    cat << EOF > $out/bin/meteor
    #!${runtimeShell}

    if [[ ! -f \$HOME/.meteor/package-metadata/v2.0.1/packages.data.db ]]; then
      mkdir -p \$HOME/.meteor/package-metadata/v2.0.1
      cp $out/package-metadata/v2.0.1/packages.data.db "\$HOME/.meteor/package-metadata/v2.0.1"
      chown "\$(whoami)" "\$HOME/.meteor/package-metadata/v2.0.1/packages.data.db"
      chmod +w "\$HOME/.meteor/package-metadata/v2.0.1/packages.data.db"
    fi

    $out/dev_bundle/bin/node --no-wasm-code-gc \''${TOOL_NODE_FLAGS} $out/tools/index.js "\$@"
    EOF
    chmod +x $out/bin/meteor
  '';

  postFixup = lib.optionalString stdenv.isLinux ''
    # Patch Meteor to dynamically fixup shebangs and ELF metadata where
    # necessary.
    pushd $out
    patch -p1 < ${./main.patch}
    popd
    substituteInPlace $out/tools/cli/main.js \
      --replace "@INTERPRETER@" "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --replace "@RPATH@" "${lib.makeLibraryPath [ stdenv.cc.cc zlib ]}" \
      --replace "@PATCHELF@" "${patchelf}/bin/patchelf"

    # Patch node.
    patchelf \
      --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
      --set-rpath "$(patchelf --print-rpath $out/dev_bundle/bin/node):${stdenv.cc.cc.lib}/lib" \
      $out/dev_bundle/bin/node

    # Patch mongo.
    for p in $out/dev_bundle/mongodb/bin/mongo{,d}; do
      patchelf \
        --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
        --set-rpath "$(patchelf --print-rpath $p):${lib.makeLibraryPath [ stdenv.cc.cc zlib ]}" \
        $p
    done

    # Patch node dlls.
    for p in $(find $out/packages -name '*.node'); do
      patchelf \
        --set-rpath "$(patchelf --print-rpath $p):${stdenv.cc.cc.lib}/lib" \
        $p || true
    done
  '';

  meta = with lib; {
    description = "Complete open source platform for building web and mobile apps in pure JavaScript";
    homepage = "https://www.meteor.com/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.mit;
    platforms = builtins.attrNames srcs;
    maintainers = with maintainers; [ cstrahan ];
  };
}
