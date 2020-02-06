{ stdenv, fetchpatch, fetchurl, python2Packages, librsync, ncftp, gnupg
, gnutar
, par2cmdline
, utillinux
, rsync
, backblaze-b2, makeWrapper }:

python2Packages.buildPythonApplication rec {
  pname = "duplicity";
  version = "0.7.19";

  src = fetchurl {
    url = "https://code.launchpad.net/duplicity/${stdenv.lib.versions.majorMinor version}-series/${version}/+download/${pname}-${version}.tar.gz";
    sha256 = "0ag9dknslxlasslwfjhqgcqbkb1mvzzx93ry7lch2lfzcdd91am6";
  };
  patches = [
    ./gnutar-in-test.patch
    ./use-installed-scripts-in-test.patch

    # The following patches improve the performance of installCheckPhase:
    # Ensure all duplicity output is captured in tests
    (fetchpatch {
      extraPrefix = "";
      sha256 = "07ay3mmnw8p2j3v8yvcpjsx0rf2jqly9ablwjpmry23dz9f0mxsd";
      url = "https://bazaar.launchpad.net/~duplicity-team/duplicity/0.8-series/diff/1359.2.1";
    })
    # Minimize time spent sleeping between backups
    (fetchpatch {
      extraPrefix = "";
      sha256 = "0v99q6mvikb8sf68gh3s0zg12pq8fijs87fv1qrvdnc8zvs4pmfs";
      url = "https://bazaar.launchpad.net/~duplicity-team/duplicity/0.8-series/diff/1359.2.2";
    })
    # Remove unnecessary sleeping after running backups in tests
    (fetchpatch {
      extraPrefix = "";
      sha256 = "1bmgp4ilq2gwz2k73fxrqplf866hj57lbyabaqpkvwxhr0ch1jiq";
      url = "https://bazaar.launchpad.net/~duplicity-team/duplicity/0.8-series/diff/1359.2.3";
    })
  ] ++ stdenv.lib.optionals stdenv.isLinux [
    ./linux-disable-timezone-test.patch
  ];

  buildInputs = [ librsync makeWrapper python2Packages.wrapPython ];
  propagatedBuildInputs = [ backblaze-b2 ] ++ (with python2Packages; [
    boto cffi cryptography ecdsa enum idna pygobject3 fasteners
    ipaddress lockfile paramiko pyasn1 pycrypto six pydrive
  ]);
  checkInputs = [
    gnupg  # Add 'gpg' to PATH.
    gnutar  # Add 'tar' to PATH.
    librsync  # Add 'rdiff' to PATH.
    par2cmdline  # Add 'par2' to PATH.
  ] ++ stdenv.lib.optionals stdenv.isLinux [
    utillinux  # Add 'setsid' to PATH.
  ] ++ (with python2Packages; [ lockfile mock pexpect ]);

  postInstall = ''
    wrapProgram $out/bin/duplicity \
      --prefix PATH : "${stdenv.lib.makeBinPath [ gnupg ncftp rsync ]}"

    wrapPythonPrograms
  '';

  preCheck = ''
    wrapPythonProgramsIn "$PWD/testing/overrides/bin" "$pythonPath"

    # Add 'duplicity' to PATH for tests.
    # Normally, 'setup.py test' adds 'build/scripts-2.7/' to PATH before running
    # tests. However, 'build/scripts-2.7/duplicity' is not wrapped, so its
    # shebang is incorrect and it fails to run inside Nix' sandbox.
    # In combination with use-installed-scripts-in-test.patch, make 'setup.py
    # test' use the installed 'duplicity' instead.
    PATH="$out/bin:$PATH"

    # Don't run developer-only checks (pep8, etc.).
    export RUN_CODE_TESTS=0
  '' + stdenv.lib.optionalString stdenv.isDarwin ''
    # Work around the following error when running tests:
    # > Max open files of 256 is too low, should be >= 1024.
    # > Use 'ulimit -n 1024' or higher to correct.
    ulimit -n 1024
  '';

  # TODO: Fix test failures on macOS 10.13:
  #
  # > OSError: out of pty devices
  doCheck = !stdenv.isDarwin;

  meta = with stdenv.lib; {
    description = "Encrypted bandwidth-efficient backup using the rsync algorithm";
    homepage = https://www.nongnu.org/duplicity;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ peti ];
    platforms = platforms.unix;
  };
}
