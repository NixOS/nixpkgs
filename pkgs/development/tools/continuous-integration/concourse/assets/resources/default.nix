{ callPackage }:
rec {

  git = callPackage ./git-resource {};

  docker-image = callPackage ./docker-image-resource {};

  registry-image = callPackage ./registry-image-resource {};

  time = callPackage ./time-resource {};
}
