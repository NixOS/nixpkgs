1{
  /python/{
    N;
    # add script folder to path, unless we interfere with a docstring
    /\nr"""/b skip-python-path-patch
    s!\n!\nimport sys; sys.path.insert(0,'@scriptsFolder@')\n!
    :skip-python-path-patch
  }

  /^#!.*perl/{
    # add script folder to @INC
    s!$! -I@scriptsFolder@!
  }

  /^eval/{
    # most likely the weird perl shebang
    N
    /^eval '(exit \$?0)' && eval 'exec perl -S \$0 \${1+"\$@"}' && eval 'exec perl -S \$0 \$argv:q'\n *if 0;$/{
      x; s/.*/patching weird perl shebang/; w /dev/stderr
      x; s|^.*$|#!@interpPerl@ -I@scriptsFolder@|
    }
  }
}

# patch 'exec interpreter'
/exec java /{
  x; s/.*/patching exec java/; w /dev/stderr
  x; s|exec java |exec '@interpJava@' |g
  /exec ''/{
    x; s/^.*$/error: java missing from PATH/; w /dev/stderr
    q 1
  }
}

/exec perl /{
  x; s/.*/patching exec perl/; w /dev/stderr
  x; s|exec perl |exec @interpPerl@ -I@scriptsFolder@ |g
  /exec ''/{
    x; s/^.*$/error: perl missing from PATH/; w /dev/stderr
    q 1
  }
}

/exec wish /{
  x; s/.*/patching exec wish/; w /dev/stderr
  x; s|exec wish |exec '@interpWish@' |g
  /exec ''/{
    x; s/^.*$/error: wish missing from PATH/; w /dev/stderr
    q 1
  }
}

# make jar wrappers work without kpsewhich
s!^jarpath=`kpsewhich --progname=[^ ]* --format=texmfscripts \([^ ]*\)`$!jarpath=@scriptsFolder@/\1!g

# replace CYGWIN grep test with bash builtin
s!echo "$kernel" | grep CYGWIN >/dev/null;![[ "$kernel" == *CYGWIN* ]]!g
