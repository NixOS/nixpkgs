{ lib, stdenv, fetchurl, vscode-utils, extractNuGet
, icu, curl, openssl, lttng-ust, autoPatchelfHook
, python3
, pythonUseFixed ? false       # When `true`, the python default setting will be fixed to specified.
                               # Use version from `PATH` for default setting otherwise.
                               # Defaults to `false` as we expect it to be project specific most of the time.
, ctagsUseFixed ? true, ctags  # When `true`, the ctags default setting will be fixed to specified.
                               # Use version from `PATH` for default setting otherwise.
                               # Defaults to `true` as usually not defined on a per projet basis.
}:

assert ctagsUseFixed -> null != ctags;

let
  pythonDefaultsTo = if pythonUseFixed then "${python3}/bin/python" else "python";
  ctagsDefaultsTo = if ctagsUseFixed then "${ctags}/bin/ctags" else "ctags";

  # The arch tag comes from 'PlatformName' defined here:
  # https://github.com/Microsoft/vscode-python/blob/master/src/client/activation/types.ts
  arch =
    if stdenv.isLinux && stdenv.isx86_64 then "linux-x64"
    else if stdenv.isDarwin then "osx-x64"
    else throw "Only x86_64 Linux and Darwin are supported.";

  languageServerSha256 = {
    linux-x64 = "1pmj5pb4xylx4gdx4zgmisn0si59qx51n2m1bh7clv29q6biw05n";
    osx-x64 = "0ishiy1z9dghj4ryh95vy8rw0v7q4birdga2zdb4a8am31wmp94b";
  }.${arch};

  # version is languageServerVersion in the package.json
  languageServer = extractNuGet rec {
    name = "Python-Language-Server";
    version = "0.5.30";

    src = fetchurl {
      url = "https://pvsc.azureedge.net/python-language-server-stable/${name}-${arch}.${version}.nupkg";
      sha256 = languageServerSha256;
    };
  };
in vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "python";
    publisher = "ms-python";
    version = "2020.3.71659";
    sha256 = "1smhnhkfchmljz8aj1br70023ysgd2hj6pm1ncn1jxphf89qi1ja";
  };

  buildInputs = [
    icu
    curl
    openssl
    lttng-ust
  ];

  nativeBuildInputs = [
    autoPatchelfHook
    python3.pkgs.wrapPython
  ];

  pythonPath = with python3.pkgs; [
    setuptools
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

    patchPythonScript "$out/$installPrefix/pythonFiles/lib/python/isort/main.py"
  '';

  meta = with lib; {
    license = licenses.mit;
    maintainers = [ maintainers.jraygauthier ];
  };
}
