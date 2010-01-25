{ fetchurl, stdenv, makeWrapper, perl, LWP, URI, HTMLParser
, HTTPServerSimple, Parent }:

stdenv.mkDerivation rec {
  name = "swec-0.4";

  src = fetchurl {
    url = "http://random.zerodogg.org/files/${name}.tar.bz2";
    sha256 = "1m3971z4z1wr0paggprfz0n8ng8vsnkc9m6s3bdplgyz7qjk6jwx";
  };

  buildInputs = [ makeWrapper perl LWP URI HTMLParser ]
   ++ stdenv.lib.optional doCheck [ HTTPServerSimple Parent ];

  configurePhase =
    '' for i in swec tests/{runTests,testServer}
       do
         sed -i "$i" -e's|/usr/bin/perl|${perl}/bin/perl|g'
       done
    '';

  buildPhase  = "true";
  installPhase =
    '' make install prefix="$out"

       ensureDir "$out/share/${name}"
       cp -v default.sdf "$out/share/${name}"
       sed -i "$out/bin/swec" -e"s|realpath(\$0)|'$out/share/${name}/swec'|g"

       wrapProgram "$out/bin/swec" \
         --prefix PERL5LIB : \
         ${stdenv.lib.concatStringsSep ":"
             (map (x: "${x}/lib/perl5/site_perl") [ LWP URI HTMLParser ])}
    '';

  doCheck = true;
  checkPhase = "make test";

  meta = {
    homepage = http://random.zerodogg.org/swec/;

    description = "Simple Web Error Checker (SWEC)";

    longDescription =
      '' SWEC (Simple Web Error Checker) is a program that automates testing
         of dynamic websites.  It parses each HTML file it finds for links,
         and if those links are within the site specified (ie. local, not
         external), it will check that page as well.  In this respect it
         works a lot like a crawler, in that it'll click on any link it finds
         (more notes about this later).

         In addition to parsing and locating links, it will also parse the
         pages looking for known errors and report those (such as Mason or
         PHP errors), and will report if a page can not be read (by either
         returning a 404, 500 or similar).

         Since you may often want SWEC to be logged in on your site, you have
         to be careful.  When logged in, SWEC will still click on all links
         it finds, including things like 'join group' or 'delete account'
         (though it has some magic trying to avoid the latter).  Therefore it
         is highly recommended that when you run SWEC as a logged-in user on
         a site, use a test server, not the live one.

         Running SWEC on a live site without being logged in as a user is
         perfectly fine, it won't do anything a normal crawler wouldn't do
         (well, not exactly true, SWEC will ignore robots.txt).
      '';

    license = "GPLv3+";

    maintainers = [ stdenv.lib.maintainers.ludo ];
  };
}
