{ callPackage, ... }@args:
callPackage ./generic.nix ({
  version = "12.1.0";
  hash = "sha256-rM8ehf4Bb+IvbLLeZEfQZnq6ViAp4d3RiYv1lGYbrOc=";
  vendorHash = "sha256-euzu6GROCZnmawLnh549ETlfLDqKFuUG9YM6klXO3z0=";
  cargoHash = "sha256-p8N07EITd+EAMJxMqBtg+1kOuqa94e5c3NtT3Z4VL6g=";
  yarnHash = "sha256-zwKjuP85VCCghpRdwGtaul9VtMF5ByMJ45QU7wgrteg=";
} // builtins.removeAttrs args [ "callPackage" ])
