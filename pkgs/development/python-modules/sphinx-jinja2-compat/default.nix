{
  buildPythonPackage,
  fetchPypi,
  whey,
  whey-pth,
  jinja2,
  markupsafe,
  standard-imghdr,
  lib,
  fetchFromGitHub,
  fetchurl,
  git,
}:
buildPythonPackage rec {
  pname = "sphinx-jinja2-compat";
  version = "0.4.1";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "sphinx_jinja2_compat";
    hash = "sha256-AYjwgC1Cw9pymXUztVoAgVZZp40/gdS0dHsfsVpXKOY=";
  };

  build-system = [
    whey
    whey-pth
  ];

  dependencies = [
    jinja2
    markupsafe
    (standard-imghdr.overrideAttrs (old: rec {
      version = "3.10.14";

      src = fetchFromGitHub {
        owner = "youknowone";
        repo = "python-deadlib";
        tag = "v${version}";
        hash = "sha256-Q6U4yutjcbcMxrCfoYC5mAMMCvz3YxsF7UrBuFBoSvk=";
      };

      # The patch contains binary files, so it has to be applied manually: https://github.com/NixOS/nixpkgs/issues/204320
      patchPhase = ''
        ${lib.getExe git} apply -p2 ${
          (fetchurl {
            # https://github.com/youknowone/python-deadlib/issues/17
            url = "https://github.com/youknowone/python-deadlib/commit/de84a362836ef791c354c33defe8094597fc3e2c.patch";
            hash = "sha256-8ajrto2odQUW6Nj6QalFbsXGWT64ezrzVJoq87xCaMk=";
          })
        }
      '';
    }))
  ];

  pythonImportsCheck = [ "sphinx_jinja2_compat" ];

  pythonNamespaces = [ "sphinx_jinja2_compat" ];

  meta = {
    description = "Patches Jinja2 v3 to restore compatibility with earlier Sphinx versions.";
    homepage = "https://github.com/sphinx-toolbox/sphinx-jinja2-compat";
    license = lib.licenses.mit;
  };
}
