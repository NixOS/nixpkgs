{ lib, fetchgit, python3Packages, fusePackages }:

let
  block-tracing = python3Packages.buildPythonPackage rec {
    pname = "block_tracing";
    version = "1.0.1";

    src = python3Packages.fetchPypi {
      inherit pname version;
      sha256 = "9faa009a702a8f2f605ebb78314d5ca2a2a93543d061038a3d3a978c93385e68";
    };
  };
  privy = python3Packages.buildPythonPackage rec {
    pname = "privy";
    version = "6.0.0";
    format = "wheel";

    src = python3Packages.fetchPypi {
      inherit pname version;
      format = "wheel";
      sha256 = "e68679bb4006ce83206d9a7af1158cf4d56a2ed6861ee39276907be618dfb8d9";
    };

    propagatedBuildInputs = [
      python3Packages.cryptography
      python3Packages.argon2_cffi
    ];
  };
  fusepyng = python3Packages.buildPythonPackage rec {
    pname = "fusepyng";
    version = "1.0.7";

    src = python3Packages.fetchPypi {
      inherit pname version;
      sha256 = "sha256-i09u+B6GAPI9p1CRaayyYVWC7xFtRqKhrUt+Uw2PiZ8=";
    };

  };
  userspacefs = python3Packages.buildPythonPackage rec {
    pname = "userspacefs";
    version = "2.0.5";

    src = python3Packages.fetchPypi {
      inherit pname version;
      sha256 = "sha256-XW9f+m05SI8cdDfF6q6Pq/SRbKzqtIOjFzoY5nibGGw=";
    };

    buildInputs = [
      fusePackages.fuse_2
    ];

    # crashes looking for libfuse in build_ext (?)
    doCheck = false;

    propagatedBuildInputs = [
      fusepyng
    ];
  };
in
python3Packages.buildPythonApplication rec {
  pname = "dbxfs";
  version = "1.0.58";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "sha256-vDuv5QPwAMFaDxgObdqRMCymdqSYmCI9gSFlZjiTIxs=";
  };

  # IndentationError at dbxfs/macos_proxies_crash_fix.py", line 15
  doCheck = false;

  propagatedBuildInputs = [
    python3Packages.keyring
    python3Packages.keyrings-alt
    python3Packages.dropbox
    python3Packages.appdirs
    python3Packages.sentry-sdk
    block-tracing
    privy
    userspacefs
  ];

  buildInputs = [
    fusePackages.fuse_2
  ];

  meta = with lib; {
    description = "Mounts a Dropbox folder as if it were a local filesystem or SMB share";
    homepage = "https://thelig.ht/code/dbxfs/";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.mausch ];
  };
}
