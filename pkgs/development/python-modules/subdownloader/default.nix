{ stdenv
, buildPythonPackage
, fetchurl
, mmpython
, pyqt4
}:

buildPythonPackage rec {
  version = "2.0.18";
  pname = "subdownloader";

  src = fetchurl {
    url = "https://launchpad.net/subdownloader/trunk/2.0.18/+download/subdownloader_2.0.18.orig.tar.gz";
    sha256 = "0manlfdpb585niw23ibb8n21mindd1bazp0pnxvmdjrp2mnw97ig";
  };

  propagatedBuildInputs = [ mmpython pyqt4 ];

  setup = ''
    import os
    import sys

    try:
        if os.environ.get("NO_SETUPTOOLS"):
            raise ImportError()
        from setuptools import setup, Extension
        SETUPTOOLS = True
    except ImportError:
        SETUPTOOLS = False
        # Use distutils.core as a fallback.
        # We won t be able to build the Wheel file on Windows.
        from distutils.core import setup, Extension

    with open("README") as fp:
        long_description = fp.read()

    requirements = [ ]

    install_options = {
        "name": "subdownloader",
        "version": "2.0.18",
        "description": "Tool for automatic download/upload subtitles for videofiles using fast hashing",
        "long_description": long_description,
        "url": "http://www.subdownloader.net",

        "scripts": ["run.py"],
        "packages": ["cli", "FileManagement", "gui", "languages", "modules"],

    }
    if SETUPTOOLS:
        install_options["install_requires"] = requirements

    setup(**install_options)
  '';

  postUnpack = ''
    echo '${setup}' > $sourceRoot/setup.py
  '';

  meta = with stdenv.lib; {
    description = "Tool for automatic download/upload subtitles for videofiles using fast hashing";
    homepage = http://www.subdownloader.net;
    license = licenses.gpl3;
  };

}
