# wrap whole file into an attrset
1i{ # no indentation
$a}

# extract repository metadata
/^name 00texlive\.config$/,/^$/{
  s/^name (.*)$/"\1" = {/p
  /^$/,1i};

  s!^depend frozen/0$!  frozen = false;!p
  s!^depend frozen/1$!  frozen = true;!p
  s!^depend release/(.*)$!  year = \1;!p
  s!^depend revision/(.*)$!  revision = \1;!p
}

# form an attrmap per package
# ignore packages whose name contains "." (such as binaries) except for texlive.infra
/^name ([^.]+|texlive\.infra)$/,/^$/{
  # quote package names, as some start with a number :-/
  s/^name (.*)$/"\1" = {/p

  # extract revision
  s/^revision ([0-9]*)$/  revision = \1;/p

  # extract hashes of *.tar.xz
  s/^containerchecksum (.*)/  sha512.run = "\1";/p
  s/^doccontainerchecksum (.*)/  sha512.doc = "\1";/p
  s/^srccontainerchecksum (.*)/  sha512.source = "\1";/p

  # number of path components to strip, defaulting to 1 ("texmf-dist/")
  /^relocated 1/i\  stripPrefix = 0;

  # extract version and clean unwanted chars from it
  /^catalogue-version/y/ \/~/_--/
  /^catalogue-version/s/[\#,:\(\)]//g
  s/^catalogue-version_(.*)/  version = "\1";/p

  # extract deps
  /^depend ([^.]+|texlive\.infra)$/{
    # open a list
    i\  deps = [

    # loop through following depend lines
    :next-dep
      s/^\n?depend ([^.]+|texlive\.infra)$/    "\1"/p # print dep
      s/^.*$//                                        # clear pattern space
      N; /^\ndepend /b next-dep

    # close the list
    i\  ];
    D # restart cycle from the current line
  }

  # detect presence of notable files
  /^runfiles /{
    s/^.*$//  # ignore the first line

    # read all files
    :next-file
      N
      s/\n / /    # remove newline
      t next-file # loop if previous line matched

    / (RELOC|texmf-dist)\//i\  hasRunfiles = true;
    / tlpkg\//i\  hasTlpkg = true;
    D # restart cycle from the current line
  }

  # extract postaction scripts (right now, at most one per package, so a string suffices)
  s/^postaction script file=(.*)$/  postactionScript = "\1";/p

  # extract hyphenation patterns and formats
  # (this may create duplicate lines, use uniq to remove them)
  /^execute\sAddHyphen/i\  hasHyphens = true;
  /^execute\sAddFormat/i\  hasFormats = true;

  # close attrmap
  /^$/i};
}
