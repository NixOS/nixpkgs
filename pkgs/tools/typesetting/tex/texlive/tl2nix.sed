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
  # quote invalid names
  s/^name ([0-9].*|texlive\.infra)$/"\1" = {/p
  s/^name (.*)$/\1 = {/p

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

  /^catalogue-license/{
    # wrap licenses in quotes
    s/ ([^ ]+)/ "\1"/g
    # adjust naming as in nixpkgs, the full texts of the licenses are available at https://www.ctan.org/license/${licenseName}
    s/"(cc-by(-sa)?-[1-4])"/"\10"/g
    s/"apache2"/"asl20"/g
    s/"artistic"/"artistic1-cl8"/g
    s/"bsd"/"bsd3"/g          # license text does not match exactly, but is pretty close
    s/"bsd4"/"bsdOriginal"/g
    s/"collection"/"free"/g   # used for collections of individual packages with distinct licenses. As TeXlive only contains free software, we can use "free" as a catchall
    s/"fdl"/"fdl13Only"/g
    s/"gpl1?"/"gpl1Only"/g
    s/"gpl2\+"/"gpl2Plus"/g
    s/"gpl3\+"/"gpl3Plus"/g
    s/"lgpl"/"lgpl2"/g
    s/"lgpl2\.1"/"lgpl21"/g
    s/"lppl"/"lppl13c"/g      # not used consistently, sometimes "lppl" refers to an older version of the license
    s/"lppl1\.2"/"lppl12"/g
    s/"lppl1\.3"/"lppl13c"/g  # If a work refers to LPPL 1.3 as its license, this is interpreted as the latest version of the 1.3 license (https://www.latex-project.org/lppl/)
    s/"lppl1\.3a"/"lppl13a"/g
    s/"lppl1\.3c"/"lppl13c"/g
    s/"other-free"/"free"/g
    s/"opl"/"opubl"/g
    s/"pd"/"publicDomain"/g

    s/^catalogue-license (.*)/  license = [ \1 ];/p
  }

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
