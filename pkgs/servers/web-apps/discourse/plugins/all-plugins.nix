{ mkDiscoursePlugin, newScope, fetchFromGitHub, ... }@args:
let
  callPackage = newScope args;
in
{
  discourse-calendar = callPackage ./discourse-calendar {};
  discourse-canned-replies = callPackage ./discourse-canned-replies {};
  discourse-checklist = callPackage ./discourse-checklist {};
  discourse-data-explorer = callPackage ./discourse-data-explorer {};
  discourse-github = callPackage ./discourse-github {};
  discourse-ldap-auth = callPackage ./discourse-ldap-auth {};
  discourse-math = callPackage ./discourse-math {};
  discourse-migratepassword = callPackage ./discourse-migratepassword {};
  discourse-openid-connect = callPackage ./discourse-openid-connect {};
  discourse-solved = callPackage ./discourse-solved {};
  discourse-spoiler-alert = callPackage ./discourse-spoiler-alert {};
  discourse-yearly-review = callPackage ./discourse-yearly-review {};
}
