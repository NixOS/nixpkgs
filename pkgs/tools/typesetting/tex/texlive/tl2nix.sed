# wrap whole file into an attrset
1itl: { # no indentation
$a}

# form an attrmap per package
# ignore packages whose name contains "." (such as binaries)
/^name ([^.]+)$/,/^$/{
  # quote package names, as some start with a number :-/
  s/^name (.*)$/"\1" = {/p
  /^$/,1i};

  # extract revision
  s/^revision ([0-9]*)$/  revision = \1;/p

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
  /^depend [^.]+$/{
    s/^depend (.+)$/  deps."\1" = tl."\1";/

    # loop through following depend lines
    :next
      h ; N     # save & read next line
      s/\ndepend (.+)\.(.+)$//
      s/\ndepend (.+)$/\n  deps."\1" = tl."\1";/
      t next    # loop if the previous lines matched

    x; p; x     # print saved deps
    s/^.*\n//   # remove deps, resume processing
  }

  # extract hyphenation patterns and formats
  # (this may create duplicate lines, use uniq to remove them)
  /^execute\sAddHyphen/i\  hasHyphens = true;
  /^execute\sAddFormat/i\  hasFormats = true;
}
