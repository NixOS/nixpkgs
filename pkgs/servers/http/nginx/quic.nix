{
  callPackage,
  nginxMainline,
  ...
}@args:

callPackage ./generic.nix args {
  pname = "nginxQuic";

  inherit (nginxMainline) src version;

  configureFlags = [
    "--with-http_v3_module"
  ];
}
