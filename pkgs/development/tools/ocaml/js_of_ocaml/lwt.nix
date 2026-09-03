{
  lib,
  buildDunePackage,
  js_of_ocaml-ppx,
  js_of_ocaml,
  lwt,
  lwt_log,
  loggerSupport ? !lib.versionAtLeast lwt.version "6.0.0",
}:

buildDunePackage {
  pname = "js_of_ocaml-lwt";

  inherit (js_of_ocaml) version src meta;

  buildInputs = [ js_of_ocaml-ppx ];

  propagatedBuildInputs = [
    js_of_ocaml
    lwt
  ]
  ++ lib.optional loggerSupport lwt_log;
}
