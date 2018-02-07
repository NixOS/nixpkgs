{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  version = "1.12.2";
  sha256 = "05h4rwja7170z0l979yjghy9i9ichllwhicylzpmmyyml6fkfprh";
})
