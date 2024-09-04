{ callPackage }:

{
  steampipe-plugin-aws = callPackage ./steampipe-plugin-aws { };
  steampipe-plugin-github = callPackage ./steampipe-plugin-github { };
}
