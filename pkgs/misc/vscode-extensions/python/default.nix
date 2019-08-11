{ lib, stdenv, fetchurl, vscode-utils, extractNuGet
, icu, curl, openssl, lttng-ust, autoPatchelfHook
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
  arch =
    if stdenv.isLinux && stdenv.isx86_64 then "linux-x64"
    else if stdenv.isDarwin then "osx-x64"
    else throw "Only x86_64 Linux and Darwin are supported.";

  languageServerSha256 = {
    "linux-x64" = "0j9251f8dfccmg0x9gzg1cai4k5zd0alcfpb0443gs4jqakl0lr2";
    "osx-x64" = "070qwwl08fa24rsnln4i5x9mfriqaw920l6v2j8d1r0zylxnyjsa";
  }."${arch}";

  # version is languageServerVersion in the package.json
  languageServer = extractNuGet rec {
    name = "Python-Language-Server";
    version = "0.3.40";

    src = fetchurl {
      url = "https://pvsc.azureedge.net/python-language-server-stable/${name}-${arch}.${version}.nupkg";
      sha256 = languageServerSha256;
    };
  };
in vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "python";
    publisher = "ms-python";
    version = "2019.6.24221";
    sha256 = "1l82y3mbplzipcij5a0wqlykypik0sbba4hwr2r4vwiwb6kxscmx";
  };

  buildInputs = [
    icu
    curl
    openssl
    lttng-ust
  ];

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  postPatch = ''
    # Patch `packages.json` so that nix's *python* is used as default value for `python.pythonPath`.
    substituteInPlace "./package.json" \
      --replace "\"default\": \"python\"" "\"default\": \"${pythonDefaultsTo}\""

    # Patch `packages.json` so that nix's *ctags* is used as default value for `python.workspaceSymbols.ctagsPath`.
    substituteInPlace "./package.json" \
      --replace "\"default\": \"ctags\"" "\"default\": \"${ctagsDefaultsTo}\""
  '';

  postInstall = ''
    mkdir -p "$out/$installPrefix/languageServer.${languageServer.version}"
    cp -R --no-preserve=ownership ${languageServer}/* "$out/$installPrefix/languageServer.${languageServer.version}"
    chmod -R +wx "$out/$installPrefix/languageServer.${languageServer.version}"
  '';

  meta = with lib; {
    license = licenses.mit;
    maintainers = [ maintainers.jraygauthier ];
  };
}
