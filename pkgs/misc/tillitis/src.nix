{ lib
, stdenv
, fetchFromGitHub
}:

fetchFromGitHub {
  owner = "tillitis";
  repo = "tillitis-key1";
  rev = "47c7e55cba43673ea72070670a2b205841392316";
  hash = "sha256-WjIWaQh57T6F+IZx5b0M4i3JrNGarliAw42eFT7guio=";
  passthru.version = "23.03.1";
}
