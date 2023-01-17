{ common
, patch-monitorfdhup
, ...
}:

common {
  version = "2.8.1";
  hash = "sha256-zldZ4SiwkISFXxrbY/UdwooIZ3Z/I6qKxtpc3zD0T/o=";
  patches = [
    ../../patches/flaky-tests.patch
    patch-monitorfdhup
  ];
}

