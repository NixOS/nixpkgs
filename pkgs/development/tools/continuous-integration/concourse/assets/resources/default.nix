{ callPackage, fly }:
rec {

  concourse-pipeline = callPackage ./concourse-pipeline-resource { inherit fly; };

  docker-image = callPackage ./docker-image-resource {};

  git = callPackage ./git-resource {};

  github-release = callPackage ./github-release-resource {};

  registry-image = callPackage ./registry-image-resource {};

  s3 = callPackage ./s3-resource {};

  semver = callPackage ./semver-resource {};

  time = callPackage ./time-resource {};

}
