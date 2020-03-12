{ stdenv
, fetchFromGitHub
, coreutils
}:

let
  yara = fetchFromGitHub {
    owner = "avast-tl";
    repo = "yara";
    rev = "ea101c5856941f39cad2db3012f2660d1d5c8b65";
    sha256 = "033ssx2hql5k4pv9si043s3mjq2b748ymjzif8pg6rdwh260faky";
  };
in stdenv.mkDerivation rec {
  # only fetches the yaracpp source patched to work with a local yara clone,
  # does not build anything
  pname = "yaracpp-src";
  version = "2018-10-09";
  rev = "b92bde0e59e3b75bc445227e04b71105771dee8b"; # as specified in retdec/deps/yaracpp/CMakeLists.txt

  src = fetchFromGitHub {
    inherit rev;
    owner = "avast-tl";
    repo = "yaracpp";
    sha256 = "0fan7q79j7s3bjmhsd2nw6sqyi14xgikn7mr2p4nj87lick5l4a2";
  };

  postPatch = ''
      # check if our version of yara is the same version that upstream expects
      echo "Checking version of yara"
      expected_rev="$( sed -n -e 's|.*URL https://github.com/.*/archive/\(.*\)\.zip.*|\1|p' "deps/CMakeLists.txt" )"
      if [ "$expected_rev" != '${yara.rev}' ]; then
        echo "The yara dependency has the wrong version: ${yara.rev} while $expected_rev is expected."
        exit 1
      fi

      # patch the CMakeLists.txt file to use our local copy of the dependency instead of fetching it at build time
      sed -i -e "s|URL .*|URL ${yara}|" "deps/CMakeLists.txt"

      # abuse the CONFIGURE_COMMAND to make the source writeable after copying it to the build locatoin (necessary for the build)
      sed -i -e 's|CONFIGURE_COMMAND ""|CONFIGURE_COMMAND COMMAND ${coreutils}/bin/chmod -R u+w .|' "deps/CMakeLists.txt"
    '';

  buildPhase = "# do nothing";
  configurePhase = "# do nothing";
  installPhase = ''
    mkdir -p "$out"
    cp -r * "$out"
  '';
}
