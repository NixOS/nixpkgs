{ mkDiscoursePlugin, newScope, ... }@args:
let
  callPackage = newScope args;
in
{
  discourse-assign = callPackage ./discourse-assign {};
  discourse-bbcode-color = callPackage ./discourse-bbcode-color {};
  discourse-calendar = callPackage ./discourse-calendar {};
  discourse-canned-replies = callPackage ./discourse-canned-replies {};
  discourse-chat-integration = callPackage ./discourse-chat-integration {};
  discourse-checklist = callPackage ./discourse-checklist {};
  discourse-data-explorer = callPackage ./discourse-data-explorer {};
  discourse-docs = callPackage ./discourse-docs {};
  discourse-github = callPackage ./discourse-github {};
  discourse-ldap-auth = callPackage ./discourse-ldap-auth {};
  discourse-math = callPackage ./discourse-math {};
  discourse-migratepassword = callPackage ./discourse-migratepassword {};
  discourse-oauth2-basic = callPackage ./discourse-oauth2-basic {};
  discourse-openid-connect = callPackage ./discourse-openid-connect {};
  discourse-prometheus = callPackage ./discourse-prometheus {};
  discourse-reactions = callPackage ./discourse-reactions {};
  discourse-saved-searches = callPackage ./discourse-saved-searches {};
  discourse-solved = callPackage ./discourse-solved {};
  discourse-spoiler-alert = callPackage ./discourse-spoiler-alert {};
  discourse-voting = callPackage ./discourse-voting {};
  discourse-yearly-review = callPackage ./discourse-yearly-review {};
}
