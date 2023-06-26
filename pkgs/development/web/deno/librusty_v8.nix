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
  version = "0.73.0";
  shas = {
    x86_64-linux = "sha256-rDthrqAs4yUl9BpFm8yJ2sKbUImydMMZegUBhcu6vdk=";
    aarch64-linux = "sha256-fM7yteYrPxCLNIUKvUpH6XTdD2aYsK4SEyrkknZgzLk=";
    x86_64-darwin = "sha256-3c3oNq6WJkFR7E/EeJ7CnN+JO7X5x+wSlqo39TbEDQk=";
    aarch64-darwin = "sha256-fO1R99XWfgAGcZXJX8nHbfnPZOlz28kXO7fkkeEF43A=";
  };
}
