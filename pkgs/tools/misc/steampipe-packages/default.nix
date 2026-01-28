{ callPackage }:

{
  steampipe-plugin-aws = callPackage ./steampipe-plugin-aws { };
  steampipe-plugin-azure = callPackage ./steampipe-plugin-azure { };
  steampipe-plugin-github = callPackage ./steampipe-plugin-github { };
  steampipe-plugin-kubernetes = callPackage ./steampipe-plugin-kubernetes { };
}
