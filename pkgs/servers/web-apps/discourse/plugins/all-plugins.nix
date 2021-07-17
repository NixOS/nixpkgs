{ mkDiscoursePlugin, newScope, fetchFromGitHub, ... }@args:
let
  callPackage = newScope args;
in
{
  discourse-canned-replies = callPackage ./discourse-canned-replies {};
  discourse-github = callPackage ./discourse-github {};
  discourse-math = callPackage ./discourse-math {};
  discourse-solved = callPackage ./discourse-solved {};
  discourse-spoiler-alert = callPackage ./discourse-spoiler-alert {};
  discourse-yearly-review = callPackage ./discourse-yearly-review {};
}
