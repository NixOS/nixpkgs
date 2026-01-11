{ mkDiscoursePlugin, newScope, ... }@args:
let
  callPackage = newScope args;
in
{
  discourse-bbcode-color = callPackage ./discourse-bbcode-color { };
  discourse-docs = callPackage ./discourse-docs { };
  discourse-ldap-auth = callPackage ./discourse-ldap-auth { };
  discourse-prometheus = callPackage ./discourse-prometheus { };
  discourse-saved-searches = callPackage ./discourse-saved-searches { };
  discourse-yearly-review = callPackage ./discourse-yearly-review { };
}
