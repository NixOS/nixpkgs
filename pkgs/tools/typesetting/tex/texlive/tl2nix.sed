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

  # extract short description
  /^shortdesc (.+)$/{
    s/"/\\"/g # escape quotes
    s/^shortdesc (.+)/  shortdesc = "\1";/p
  }

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
    s/"eupl"/"eupl12"/g
    s/"fdl"/"fdl13Only"/g
    s/"gpl"/"gpl1Only"/g
    s/"gpl([1-3])"/"gpl\1Only"/g
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
    s/"other-nonfree"/"unfree"/g
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

  # extract font maps
  /^execute add.*Map /{
    # open a list
    i\  fontMaps = [

    # loop through following map lines
    :next-map
      s/^\n?execute add(.*Map .*)$/    "\1"/p # print map
      s/^.*$//                              # clear pattern space
      N; /^\nexecute add.*Map /b next-map

    # close the string
    i\  ];
    D # restart cycle from the current line
  }

  # detect presence of notable files
  /^docfiles /{
    s/^.*$//  # ignore the first line

    # read all files
    :next-doc
      N
      s/\n / /   # remove newline
      t next-doc # loop if the previous lines matched

    / (texmf-dist|RELOC)\/doc\/man\//i\  hasManpages = true;
    / (texmf-dist|RELOC)\/doc\/info\//i\  hasInfo = true;

    D # restart cycle
  }

  /^runfiles /{
    s/^.*$//  # ignore the first line

    # read all files
    :next-file
      N
      s/\n / /    # remove newline
      t next-file # loop if previous line matched
    s/\n/ \n/     # add space before last newline for accurate matching below

    / (RELOC|texmf-dist)\//i\  hasRunfiles = true;
    / tlpkg\//i\  hasTlpkg = true;

    # extract script extensions
    / texmf-dist\/scripts\/.*\.(jar|lua|py|rb|sno|tcl|texlua|tlu) /{
      i\  scriptExts = [
        / texmf-dist\/scripts\/.*\.jar /i\    "jar"
        / texmf-dist\/scripts\/.*\.lua /i\    "lua"
        / texmf-dist\/scripts\/.*\.py /i\    "py"
        / texmf-dist\/scripts\/.*\.rb /i\    "rb"
        / texmf-dist\/scripts\/.*\.sno /i\    "sno"
        / texmf-dist\/scripts\/.*\.tcl /i\    "tcl"
        / texmf-dist\/scripts\/.*\.texlua /i\    "texlua"
        / texmf-dist\/scripts\/.*\.tlu /i\    "tlu"
      i\  ];
    }

    D # restart cycle from the current line
  }

  # extract postaction scripts (right now, at most one per package, so a string suffices)
  s/^postaction script file=(.*)$/  postactionScript = "\1";/p

  # extract hyphenation patterns
  /^execute\sAddHyphen\s/{
    # open a list
    i\  hyphenPatterns = [

    # create one attribute set per hyphenation pattern

    # plain keys: name, lefthyphenmin, righthyphenmin, file, file_patterns, file_exceptions, comment
    # optionally double quoted key: luaspecial, comment
    # comma-separated lists: databases, synonyms
    :next-hyphen
      s/(^|\n)execute\sAddHyphen/    {/
      s/\s+luaspecial="([^"]+)"/\n      luaspecial = "\1";/
      s/\s+(name|lefthyphenmin|righthyphenmin|file|file_patterns|file_exceptions|luaspecial|comment)=([^ \t\n]*)/\n      \1 = "\2";/g
      s/\s+(databases|synonyms)=([^ \t\n]+)/\n      \1 = [ "\2" ];/g
      s/$/\n    }/

      :split-hyphens
        s/"([^,]+),([^"]+)" ]/"\1" "\2" ]/;
        t split-hyphens   # repeat until there are no commas

      p
      s/^.*$// # clear pattern space
      N
      /^\nexecute\sAddHyphen\s/b next-hyphen

    # close the list
    i\  ];
    D # restart cycle from the current line
  }

  # extract format details
  /^execute\sAddFormat\s/{
    # open a list
    i\  formats = [

    # create one attribute set per format
    # note that format names are not unique

    # plain keys: name, engine, patterns
    # optionally double quoted key: options
    # boolean key: mode (enabled/disabled)
    # comma-separated lists: fmttriggers, patterns
    :next-fmt
      s/(^|\n)execute\sAddFormat/    {/
      s/\s+options="([^"]+)"/\n      options = "\1";/
      s/\s+(name|engine|options)=([^ \t\n]+)/\n      \1 = "\2";/g
      s/\s+mode=enabled//
      s/\s+mode=disabled/\n      enabled = false;/
      s/\s+(fmttriggers|patterns)=([^ \t\n]+)/\n      \1 = [ "\2" ];/g
      s/$/\n    }/

      :split-triggers
        s/"([^,]+),([^"]+)" ]/"\1" "\2" ]/;
        t split-triggers   # repeat until there are no commas

      p
      s/^.*$// # clear pattern space
      N
      /^\nexecute\sAddFormat\s/b next-fmt

    # close the list
    i\  ];
    D # restart cycle from the current line
  }

  # close attrmap
  /^$/i};
}

# add list of binaries from one of the architecture-specific packages
/^name ([^.]+|texlive\.infra)\.x86_64-linux$/,/^$/{
  s/^name ([0-9].*|texlive\.infra)\.x86_64-linux$/"\1".binfiles = [/p
  s/^name (.*)\.x86_64-linux$/\1.binfiles = [/p
  s!^ bin/x86_64-linux/(.+)$!  "\1"!p
  /^$/i];
}
