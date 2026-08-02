{
  fetchFromGitHub,
  lib,
  libuuid,
  mkNginxPlugin,
  psol,
  runCommand,
  zlib,
}:

mkNginxPlugin (finalAttrs: {
  pname = "pagespeed";
  version = psol.version;

  src =
    let
      moduleSrc = fetchFromGitHub {
        owner = "apache";
        repo = "incubator-pagespeed-ngx";
        rev = "v${psol.version}-stable";
        sha256 = "0ry7vmkb2bx0sspl1kgjlrzzz6lbz07313ks2lr80rrdm2zb16wp";
      };
    in
    runCommand "ngx_pagespeed"
      {
        meta = {
          description = "PageSpeed module for Nginx";
          homepage = "https://developers.google.com/speed/pagespeed/module/";
          license = lib.licenses.asl20;
        };
      }
      ''
        cp -r "${moduleSrc}" "$out"
        chmod -R +w "$out"
        ln -s "${psol}" "$out/psol"
      '';

  buildInputs = [
    zlib
    libuuid
  ]; # psol deps

  allowMemoryWriteExecute = true;

  meta = {
    description = "Automatic PageSpeed optimization";
    homepage = "https://github.com/apache/incubator-pagespeed-ngx";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
