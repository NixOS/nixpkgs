# Packaging guidelines

## buildHomeAssistantComponent

Custom components should be packaged using the
 `buildHomeAssistantComponent` function, that is provided at top-level.
It builds upon `buildPythonPackage` but uses a custom install and check
phase.

Python runtime dependencies can be directly consumed as unqualified
function arguments. Pass them into `propagatedBuildInputs`, for them to
be available to Home Assistant.

Out-of-tree components need to use python packages from
`home-assistant.python.pkgs` as to not introduce conflicting package
versions into the Python environment.


**Example Boilerplate:**

```nix
{ lib
, buildHomeAssistantcomponent
, fetchFromGitHub
}:

buildHomeAssistantComponent {
  # pname, version

  src = fetchFromGithub {
    # owner, repo, rev, hash
  };

  propagatedBuildInputs = [
    # python requirements, as specified in manifest.json
  ];

  meta = with lib; {
    # changelog, description, homepage, license, maintainers
  }
}

## Package name normalization

Apply the same normalization rules as defined for python packages in
[PEP503](https://peps.python.org/pep-0503/#normalized-names).
The name should be lowercased and dots, underlines or multiple
dashes should all be replaced by a single dash.

## Manifest check

The `buildHomeAssistantComponent` builder uses a hook to check whether
the dependencies specified in the `manifest.json` are present and
inside the specified version range.

There shouldn't be a need to disable this hook, but you can set
`dontCheckManifest` to `true` in the derivation to achieve that.
