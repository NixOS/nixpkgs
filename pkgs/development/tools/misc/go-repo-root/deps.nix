{ stdenv, lib, fetchFromGitHub, fetchhg }:

let
  goDeps = [
    {
      root = "code.google.com/p/go.net";
      src = fetchhg {
        url = "http://code.google.com/p/go.net";
        rev = "ad01a6fcc8a19d3a4478c836895ffe883bd2ceab";
        sha256 = "0s0aa8hxrpggn6wwx4x591k6abvawrmhsk8ji327pgj08fdy3ahq";
      };
    }
    {
      root = "code.google.com/p/go.text";
      src = fetchhg {
        url = "http://code.google.com/p/go.text";
        rev = "12288f41f508af9490f03a9780afa295c9b0a063";
        sha256 = "17kr0h79pznb3nn5znbh1d7dinmqjwvg5iqqk4l05569q50gqwww";
      };
    }
    {
      root = "code.google.com/p/go.tools";
      src = fetchhg {
        url = "http://code.google.com/p/go.tools";
        rev = "140fcaadc5860b1a014ec69fdeec807fe3b787e8";
        sha256 = "1vgz4kxy0p56qh6pfbs2c68156hakgx4cmrci9jbg7lnrdaz4y56";
      };
    }
    {
      root = "code.google.com/p/goauth2";
      src = fetchhg {
        url = "http://code.google.com/p/goauth2";
        rev = "afe77d958c701557ec5dc56f6936fcc194d15520";
        sha256 = "0xgkgcb97hv2rvzvh21rvydq5cc83j7sdsdb1chrymq8k7l4dzc1";
      };
    }
    {
      root = "code.google.com/p/google-api-go-client";
      src = fetchhg {
        url = "http://code.google.com/p/google-api-go-client";
        rev = "e1c259484b495133836706f46319f5897f1e9bf6";
        sha256 = "051dqhjhp3bz2xp7lv9v60xlmphbxj1vyc46wg8v74yjvqvsiwzd";
      };
    }
    {
      root = "github.com/cstrahan/go-repo-root";
      src = fetchFromGitHub {
        owner = "cstrahan";
        repo = "go-repo-root";
        rev = "90041e5c7dc634651549f96814a452f4e0e680f9";
        sha256 = "1rlzp8kjv0a3dnfhyqcggny0ad648j5csr2x0siq5prahlp48mg4";
      };
    }
  ];

in

stdenv.mkDerivation rec {
  name = "go-deps";

  buildCommand =
    lib.concatStrings
      (map (dep: ''
              mkdir -p $out/src/`dirname ${dep.root}`
              ln -s ${dep.src} $out/src/${dep.root}
            '') goDeps);
}
