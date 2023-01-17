{ common
, patch-monitorfdhup
, ...
}:

common {
  version = "2.6.1";
  hash = "sha256-E9iQ7f+9Z6xFcUvvfksTEfn8LsDfzmwrcRBC//5B3V0=";
  patches = [
    patch-monitorfdhup
  ];
}


