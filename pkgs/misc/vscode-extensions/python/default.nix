{ lib
, stdenv
, fetchurl
, unzip
, makeWrapper
, icu
, openssl
, vscode-utils
, pythonUseFixed ? false, python  # When `true`, the python default setting will be fixed to specified.
                                  # Use version from `PATH` for default setting otherwise.
                                  # Defaults to `false` as we expect it to be project specific most of the time.
, ctagsUseFixed ? true, ctags     # When `true`, the ctags default setting will be fixed to specified.
                                  # Use version from `PATH` for default setting otherwise.
                                  # Defaults to `true` as usually not defined on a per projet basis.
}:

assert pythonUseFixed -> null != python;
assert ctagsUseFixed -> null != ctags;

let
  pythonDefaultsTo = if pythonUseFixed then "${python}/bin/python" else "python";
  ctagsDefaultsTo = if ctagsUseFixed then "${ctags}/bin/ctags" else "ctags";

  # The arch tag comes from 'PlatformName' defined here:
  # https://github.com/Microsoft/vscode-python/blob/master/src/client/activation/types.ts
  archTag =
    if stdenv.isLinux && stdenv.isx86_64 then "linux-x64"
    else if stdenv.isDarwin then "osx-x64"
    else throw "Only x86_64 Linux and Darwin are supported.";

  extractNuGet = { name, version, src, ... }:
    stdenv.mkDerivation {
      inherit name version src;

      buildInputs = [ unzip ];
      dontBuild = true;
      unpackPhase = "unzip $src";
      installPhase = ''
        mkdir -p "$out"
        chmod -R +w .
        find . -mindepth 1 -maxdepth 1 | xargs cp -a -t "$out"
      '';
    };

  languageServer = extractNuGet rec {
    name="Python-Language-Server";
    version = "0.1.75";
    src = fetchurl {
      url = "https://pvsc.azureedge.net/python-language-server-stable/${name}-${archTag}.${version}.nupkg";
      sha256 = "c15937eb9e81538971794bced4d58041381d26724dc05a72b76bd7c25db5ebd5";
    };
  };

  libPath = lib.makeLibraryPath [
    stdenv.cc.cc.lib  # libstdc++.so.6
  ];
in

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "python";
    publisher = "ms-python";
    version = "2018.12.1";
    sha256 = "1cf3yll2hfililcwq6avscgi35caccv8m8fdsvzqdfrggn5h41h4";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ languageServer icu openssl ];
  dontPatchELF = true;

  buildPhase = ''
    mkdir -p "languageServer.${languageServer.version}"
    cp -R --no-preserve=ownership ${languageServer}/* "languageServer.${languageServer.version}"
    chmod -R +wx "languageServer.${languageServer.version}"

    patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "${libPath}" \
      "languageServer.${languageServer.version}/Microsoft.Python.LanguageServer"
  '';

  fixupPhase = ''
    wrapProgram `find $out -name Microsoft.Python.LanguageServer` --prefix LD_LIBRARY_PATH ":" ${icu}/lib:${openssl.out}/lib
  '';

  postPatch = ''
    # Patch `packages.json` so that nix's *python* is used as default value for `python.pythonPath`.
    substituteInPlace "./package.json" \
      --replace "\"default\": \"python\"" "\"default\": \"${pythonDefaultsTo}\""

    # Patch `packages.json` so that nix's *ctags* is used as default value for `python.workspaceSymbols.ctagsPath`.
    substituteInPlace "./package.json" \
      --replace "\"default\": \"ctags\"" "\"default\": \"${ctagsDefaultsTo}\""
  '';

  meta = with lib; {
    license = licenses.mit;
    maintainers = [ maintainers.jraygauthier maintainers.sdorminey ];
  };
}
