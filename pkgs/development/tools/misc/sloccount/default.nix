{ stdenv, fetchurl, perlPackages, coreutils, flex, glibcLocales, makeWrapper }:

perlPackages.buildPerlPackage rec {
  pname = "sloccount";
  version = "2.26";

  src = fetchurl {
    url = "https://www.dwheeler.com/sloccount/${pname}-${version}.tar.gz";
    sha256 = "0ayiwfjdh1946asah861ah9269s5xkc8p5fv1wnxs9znyaxs4zzs";
  };

  # needed for the standard buildPerlPackage builder
  postPatch = "touch Makefile.PL";

  nativeBuildInputs = [ flex makeWrapper ];

  outputs = [ "out" ];

  makeFlags = [ "PREFIX=$(out)" "CC=cc" ];

  checkPhase = ''HOME="$TMPDIR" PATH="$PWD:$PATH" make test'';

  preInstall = "mkdir -p $out/bin";

  # coreutils is needed for wc and md5sum
  postInstall = ''
    mv $out/bin $out/libexec

    makeWrapper $out/libexec/sloccount $out/bin/sloccount \
      --prefix PATH : $out/libexec:${stdenv.lib.makeBinPath [ coreutils ]} \
      --set LOCALE_ARCHIVE ${glibcLocales}/lib/locale/locale-archive
  '';

  meta = with stdenv.lib; {
    description = "Set of tools for counting physical Source Lines of Code (SLOC)";

    longDescription = ''
      This is the home page of "SLOCCount", a set of tools for
      counting physical Source Lines of Code (SLOC) in a large number
      of languages of a potentially large set of programs.  This suite
      of tools was used in my papers More than a Gigabuck: Estimating
      GNU/Linux's Size and Estimating Linux's Size to measure the SLOC
      of entire GNU/Linux distributions, and my essay Linux Kernel
      2.6: It's Worth More!  Others have measured Debian GNU/Linux and
      the Perl CPAN library using this tool suite.
    '';

    homepage = "https://www.dwheeler.com/sloccount/";
    license = licenses.gpl2Plus;
    maintainers = [ ];
  };
}
