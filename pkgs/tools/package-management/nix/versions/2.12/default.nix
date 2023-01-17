{ common
, patch-sqlite-exception
, patch-monitorfdhup
, ...
}:

common {
  version = "2.12.0";
  hash = "sha256-sQ9C101CL/eVN5JgH91ozHFWU4+bXr8/Fi/8NQk6xRI=";
  patches = [
    ../../patches/flaky-tests.patch
    patch-sqlite-exception
    patch-monitorfdhup
  ];
}
