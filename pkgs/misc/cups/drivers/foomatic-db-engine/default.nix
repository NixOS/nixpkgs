{ lib
, perlPackages
, fetchFromGitHub
, withCupsAccess ? false  # needed to access local cups server
, cups
, cups-filters
, curl
, withSocketAccess ? false  # needed to access network printers
, netcat-gnu
, withSMBAccess ? false  # needed to access SMB-connected printers
, samba
, autoconf
, automake
, file
, makeWrapper
}:

perlPackages.buildPerlPackage {
  pname = "foomatic-db-engine";
  version = "unstable-2022-05-03";

  src = fetchFromGitHub {
    # there is also a daily snapshot at the `downloadPage`,
    # but it gets deleted quickly and would provoke 404 errors
    owner = "OpenPrinting";
    repo = "foomatic-db-engine";
    rev = "2e6f14b54748fa121a4d2e3d480010e10b070c5a";
    hash = "sha256-m7FQTxWmawbtm24h8UqznGKXgX41JhOtyyFMRwEhm5k=";
  };

  outputs = [ "out" ];

  propagatedBuildInputs = [
    perlPackages.Clone
    perlPackages.DBI
    perlPackages.XMLLibXML
  ];

  buildInputs =
       # provide some "cups-*" commands to `foomatic-{configure,printjob}`
       # so that they can manage a local cups server (add queues, add jobs...)
       lib.optionals withCupsAccess [ cups cups-filters curl ]
       # the commands `foomatic-{configure,getpjloptions}` need
       # netcat if they are used to query or alter a network
       # printer via AppSocket/HP JetDirect protocol
    ++ lib.optional withSocketAccess netcat-gnu
       # `foomatic-configure` can be used to access printers that are
       # shared via the SMB protocol, but it needs the `smbclient` binary
    ++ lib.optional withSMBAccess samba
  ;

  nativeBuildInputs = [ autoconf automake file makeWrapper ];

  # sed-substitute indirection is more robust against
  # characters in paths that might need escaping
  prePatch = ''
    sed -Ei 's|^(S?BINSEARCHPATH=).+$|\1"@PATH@"|g' configure.ac
    substituteInPlace configure.ac --subst-var PATH
    touch Makefile.PL  # `buildPerlPackage` fails unless this exists
  '';

  preConfigure = ''
    ./make_configure
  '';

  configureFlags = [
    "--sysconfdir=${placeholder "out"}/etc"
    "LIBDIR=${placeholder "out"}/share/foomatic"
    "PERLPREFIX=${placeholder "out"}"
  ];

  postFixup = ''
    for bin in "${placeholder "out"}/bin"/*; do
      test '!' -L "$bin" || continue  # skip symlink
      wrapProgram "$bin" --set PERL5LIB "$PERL5LIB"
    done
  '';

  doCheck = false;  # no tests, would fail

  meta = {
    description = "OpenPrinting printer support database engine";
    downloadPage = "https://www.openprinting.org/download/foomatic/";
    homepage = "https://openprinting.github.io/projects/02-foomatic/";
    license = lib.licenses.gpl2Only;
    maintainers = [ lib.maintainers.yarny ];
    longDescription = ''
      Foomatic's database engine generates PPD files
      from the data in Foomatic's XML database.
      It also contains scripts to directly
      generate print queues and handle jobs.
    '';
  };
}
