{ lib, fetchurl }:

# fetchurl enriched with artifact info in passthru parsed out of the url
{ sha1, url }:

fetchurl {
  inherit sha1 url;
  passthru = let
               m = builtins.match ''(mirror://maven|https://scala-ci.typesafe.com/artifactory/scala-integration)/(.+)/([a-zA-Z0-9._-]+)/([a-zA-Z0-9._-]+)/[a-zA-Z0-9._-]+\.jar'' url;
             in
               if m == null then throw "error parsing artifact url ${url}" else
               rec {
                 groupId = lib.replaceStrings ["/"] ["."] (lib.elemAt m 1);
                 artifactId = lib.elemAt m 2;
                 version = lib.elemAt m 3;
                 spec = "${groupId}:${artifactId}:${version}";
               };
}
