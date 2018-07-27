{ lib, vscode-utils

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
in

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "python";
    publisher = "ms-python";
    version = "2018.7.0";
    sha256 = "0ab6ce722b23274a8f70d156f55d02123dd3b686397b11d4eec0831ec69dbec5";
  };

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
      maintainers = [ maintainers.jraygauthier ];
    };
}
