{ callPackage, ... }@args:
callPackage ./generic.nix ({
  version = "11.3.5";
  hash = "sha256-/InWly0jCiPBlgM/qgS6ErMv7Hhg5PW9sldda1oaUIg=";
  vendorHash = "sha256-NkiFLEHBNjxUOSuAlVugAV14yCCo3z6yhX7LZQFKhvA=";
  cargoHash = "sha256-02qo6i6GuRAYKDKA7k2hDq2O6ayEQbeGhFS2g3b9Wuo=";
  yarnHash = "sha256-kvnVmDZ/jISaaS97KM0WbPJU7Y8XWOeHrDLT0iXRyfc=";
} // builtins.removeAttrs args [ "callPackage" ])
