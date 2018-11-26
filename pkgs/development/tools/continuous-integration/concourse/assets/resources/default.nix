{ callPackage }:
rec {

  git = callPackage ./git-resource {};

  github-release = callPackage ./github-release-resource {};

  docker-image = callPackage ./docker-image-resource {};

  registry-image = callPackage ./registry-image-resource {};

  s3 = callPackage ./s3-resource {};

  time = callPackage ./time-resource {};

}
