{ stdenv, buildGoPackage, fetchFromGitLab }:
buildGoPackage rec {
  name = "loccount-${version}";
  version = "1.2";

  goPackagePath = "gitlab.com/esr/loccount";
  excludedPackages = "tests";

  src = fetchFromGitLab {
    owner = "esr";
    repo = "loccount";
    rev = version;
    sha256 = "18z7ai7wy2k9yd3w65d37apfqs3h9bc2c15y7v1bydppi44zfsdk";
  };

  meta = with stdenv.lib; {
    description = "Re-implementation of sloccount in Go";
    longDescription = ''
      loccount is a re-implementation of David A. Wheeler's sloccount tool
      in Go.  It is faster and handles more different languages. Because
      it's one source file in Go, it is easier to maintain and extend than the
      multi-file, multi-language implementation of the original.

      The algorithms are largely unchanged and can be expected to produce
      identical numbers for languages supported by both tools.  Python is
      an exception; loccount corrects buggy counting of single-quote multiline
      literals in sloccount 2.26.
    '';
    homepage="https://gitlab.com/esr/loccount";
    downloadPage="https://gitlab.com/esr/loccount/tree/master";
    license = licenses.bsd2;
    maintainers = with maintainers; [ calvertvl ];
    platforms = platforms.unix;
  };
}
