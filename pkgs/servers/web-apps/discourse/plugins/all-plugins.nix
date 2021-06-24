{ mkDiscoursePlugin, newScope, fetchFromGitHub, ... }@args:
let
  callPackage = newScope args;
in
{
  discourse-spoiler-alert = callPackage ./discourse-spoiler-alert {};
  discourse-solved = callPackage ./discourse-solved {};
  discourse-canned-replies = callPackage ./discourse-canned-replies {};
  discourse-math = callPackage ./discourse-math {};
  discourse-github = callPackage ./discourse-github {};
  discourse-yearly-review = callPackage ./discourse-yearly-review {};
}
