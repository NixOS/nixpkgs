# wrap whole file into an attrset
1itl: { # no indentation
$a}

# trash packages we don't want
/^name .*\./,/^$/d

# quote package names, as some start with a number :-/
s/^name (.*)/name "\1"/

# extract revision
s/^revision ([0-9]*)$/  revision = \1;/p

# form an attrmap per package
/^name /s/^name (.*)/\1 = {/p
/^$/,1i};

# extract hashes of *.tar.xz
s/^containerchecksum (.*)/  sha512.run = "\1";/p
s/^doccontainerchecksum (.*)/  sha512.doc = "\1";/p
s/^srccontainerchecksum (.*)/  sha512.source = "\1";/p
/^runfiles /i\  hasRunfiles = true;

# number of path components to strip, defaulting to 1 ("texmf-dist/")
/^relocated 1/i\  stripPrefix = 0;

# extract version and clean unwanted chars from it
/^catalogue-version/y/ \/~/_--/
/^catalogue-version/s/[\#,:\(\)]//g
s/^catalogue-version_(.*)/  version = "\1";/p

# extract deps
s/^depend ([^.]*)$/  deps."\1" = tl."\1";/p

