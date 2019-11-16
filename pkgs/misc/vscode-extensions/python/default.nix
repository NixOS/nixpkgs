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
    linux-x64 = "1w3y0sn6ijk1vspi4lailg1q1iy9lwslhx92c7jbrrkiaszvaqwn";
    osx-x64 = "11l4fic8cvgh1l3dq6qxi51pwhcic79zf13rhyajl5w5g13caafp";
  }.${arch};

  # version is languageServerVersion in the package.json
  languageServer = extractNuGet rec {
    name = "Python-Language-Server";
    version = "0.4.24";

    src = fetchurl {
      url = "https://pvsc.azureedge.net/python-language-server-stable/${name}-${arch}.${version}.nupkg";
      sha256 = languageServerSha256;
    };
  };
in vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "python";
    publisher = "ms-python";
    version = "2019.10.44104";
    sha256 = "1k0wws430psrl8zp9ky5mifbg02qmh2brjyqk5k9pn3y1dks5gns";
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
