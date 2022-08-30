# auto-generated file -- DO NOT EDIT!
{ rust, stdenv, fetchurl }:

let
  arch = rust.toRustTarget stdenv.hostPlatform;
  fetch_librusty_v8 = args: fetchurl {
    name = "librusty_v8-${args.version}";
    url = "https://github.com/denoland/rusty_v8/releases/download/v${args.version}/librusty_v8_release_${arch}.a";
    sha256 = args.shas.${stdenv.hostPlatform.system};
    meta = { inherit (args) version; };
  };
in
fetch_librusty_v8 {
  version = "0.49.0";
  shas = {
    x86_64-linux = "sha256-l6+NdMzYI9r2aHU7/OUhbgmc/LmAZjEFL8y8GrJ+EX8=";
    aarch64-linux = "sha256-uo+/Wsrlkm+xotoIr8xlQWoiWzMz02TKFW+olfXtpz8=";
    x86_64-darwin = "sha256-gWxljTgt6aXUzwex2zu46B9YzTvhN0Pi9C1Ll1eiohg=";
    aarch64-darwin = "sha256-/UnBIQ/wA/0biIG9vIDKylhqFJ8QCoqjKH7xiePZ/eg=";
  };
}
