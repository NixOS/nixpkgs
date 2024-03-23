# Packaging guidelines

## buildHomeAssistantComponent

Custom components should be packaged using the
 `buildHomeAssistantComponent` function, that is provided at top-level.
It builds upon `buildPythonPackage` but uses a custom install and check
phase.

Python runtime dependencies can be directly consumed as unqualified
function arguments. Pass them into `propagatedBuildInputs`, for them to
be available to Home Assistant.

Out-of-tree components need to use Python packages from
`home-assistant.python.pkgs` as to not introduce conflicting package
versions into the Python environment.


**Example Boilerplate:**

```nix
{ lib
, buildHomeAssistantcomponent
, fetchFromGitHub
}:

buildHomeAssistantComponent {
  # owner, domain, version

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
```

## Package attribute

The attribute name must reflect the domain as seen in the
`manifest.json`, which in turn will match the python module name below
in the `custom_components/` directory.

**Example:**

The project [mweinelt/ha-prometheus-sensor](https://github.com/mweinelt/ha-prometheus-sensor/blob/1.0.0/custom_components/prometheus_sensor/manifest.json#L2)
would receive the attribute name `"prometheus_sensor"`, because both
domain in the `manifest.json` as well as the module name are
`prometheus_sensor`.

## Package name

The `pname` attribute is a composition of both `owner` and `domain`.

Don't set `pname`, set `owner` and `domain` instead.

Exposing the `domain` attribute separately allows checking for
conflicting components at eval time.

## Manifest check

The `buildHomeAssistantComponent` builder uses a hook to check whether
the dependencies specified in the `manifest.json` are present and
inside the specified version range. It also makes sure derivation
and manifest agree about the domain name.

There shouldn't be a need to disable this hook, but you can set
`dontCheckManifest` to `true` in the derivation to achieve that.
