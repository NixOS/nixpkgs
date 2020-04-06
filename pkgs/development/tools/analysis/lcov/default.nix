 {stdenv, fetchurl, fetchpatch, perl, perlPackages, makeWrapper }:

stdenv.mkDerivation rec {
  name = "lcov-1.14";

  src = fetchurl {
    url = "mirror://sourceforge/ltp/${name}.tar.gz";
    sha256 = "06h7ixyznf6vz1qvksjgy5f3q2nw9akf6zx59npf0h3l32cmd68l";
  };

  patches =
    [ (fetchpatch {
        url = https://github.com/linux-test-project/lcov/commit/ebfeb3e179e450c69c3532f98cd5ea1fbf6ccba7.patch;
        sha256 = "0dalkqbjb6a4vp1lcsxd39dpn5fzdf7ihsjbiviq285s15nxdj1j";
      })
      (fetchpatch {
        url = https://github.com/linux-test-project/lcov/commit/75fbae1cfc5027f818a0bb865bf6f96fab3202da.patch;
        sha256 = "0v1hn0511dxqbf50ppwasc6vmg0m6rns7ydbdy2rdbn0j7gxw30x";
      })
    ];

  buildInputs = [ perl makeWrapper ];

  preBuild = ''
    patchShebangs bin/
    makeFlagsArray=(PREFIX=$out LCOV_PERL_PATH=$(command -v perl))
  '';

  postInstall = ''
    wrapProgram $out/bin/lcov --set PERL5LIB ${perlPackages.makeFullPerlPath [ perlPackages.PerlIOgzip perlPackages.JSON ]}
  '';

  meta = with stdenv.lib; {
    description = "Code coverage tool that enhances GNU gcov";

    longDescription =
      '' LCOV is an extension of GCOV, a GNU tool which provides information
         about what parts of a program are actually executed (i.e.,
         "covered") while running a particular test case.  The extension
         consists of a set of PERL scripts which build on the textual GCOV
         output to implement the following enhanced functionality such as
         HTML output.
      '';

    homepage = http://ltp.sourceforge.net/coverage/lcov.php;
    license = stdenv.lib.licenses.gpl2Plus;

    maintainers = with maintainers; [ dezgeg ];
    platforms = platforms.all;
  };
}
