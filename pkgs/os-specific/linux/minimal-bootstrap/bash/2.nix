{ lib
, derivationWithMeta
, fetchurl
, kaem
, tinycc
, gnumake
, gnupatch
, coreutils
, mescc-tools-extra
, bash_2_05
, live-bootstrap
}:
let
  pname = "bash";
  version = "2.05b";

  src = fetchurl {
    url = "mirror://gnu/bash/bash-${version}.tar.gz";
    sha256 = "1r1z2qdw3rz668nxrzwa14vk2zcn00hw7mpjn384picck49d80xs";
  };

  # Thanks to the live-bootstrap project!
  # See https://github.com/fosslinux/live-bootstrap/blob/1bc4296091c51f53a5598050c8956d16e945b0f5/sysa/bash-2.05b/bash-2.05b.kaem
  lbf = live-bootstrap.packageFiles {
    commit = "1bc4296091c51f53a5598050c8956d16e945b0f5";
    parent = "sysa";
    inherit pname version;
  };

  main_mk = lbf."mk/main.mk";
  common_mk = lbf."mk/common.mk";
  builtins_mk = lbf."mk/builtins.mk";

  patches = [
    # mes libc does not have locale support
    lbf."patches/mes-libc.patch"
    # int name, namelen; is wrong for mes libc, it is char* name, so we modify tinycc
    # to reflect this.
    lbf."patches/tinycc.patch"
    # add ifdef's for features we don't want
    lbf."patches/missing-defines.patch"
    # mes libc + setting locale = not worky
    lbf."patches/locale.patch"
    # We do not have /dev at this stage of the bootstrap, including /dev/tty
    lbf."patches/dev-tty.patch"
  ];
in
kaem.runCommand "${pname}-${version}" {
  inherit pname version;

  nativeBuildInputs = [
    tinycc.compiler
    gnumake
    gnupatch
    coreutils
  ];

  passthru.runCommand = name: env: buildCommand:
    derivationWithMeta ({
      inherit name buildCommand;
      builder = "${bash_2_05}/bin/bash";
      args = [
        "-e"
        (builtins.toFile "bash-builder.sh" ''
          export CONFIG_SHELL=$SHELL
          bash -eux $buildCommandPath
        '')
      ];
      passAsFile = [ "buildCommand" ];

      SHELL = "${bash_2_05}/bin/bash";
      PATH = lib.makeBinPath ((env.nativeBuildInputs or []) ++ [
        bash_2_05
        coreutils
        # provides untar, ungz, and unbz2
        mescc-tools-extra
      ]);
    } // (builtins.removeAttrs env [ "nativeBuildInputs" ]));

  passthru.tests.get-version = result:
    kaem.runCommand "${pname}-get-version-${version}" {} ''
      ${result}/bin/bash --version
      mkdir ''${out}
    '';

  meta = with lib; {
    description = "GNU Bourne-Again Shell, the de facto standard shell on Linux";
    homepage = "https://www.gnu.org/software/bash";
    license = licenses.gpl3Plus;
    maintainers = teams.minimal-bootstrap.members;
    platforms = platforms.unix;
  };
} ''
  # Unpack
  ungz --file ${src} --output bash.tar
  untar --file bash.tar
  rm bash.tar
  cd bash-${version}

  # Patch
  ${lib.concatMapStringsSep "\n" (f: "patch -Np0 -i ${f}") patches}

  # Configure
  cp ${main_mk} Makefile
  cp ${builtins_mk} builtins/Makefile
  cp ${common_mk} common.mk
  touch config.h
  touch include/version.h
  touch include/pipesize.h

  # Build
  make \
    CC="tcc -B ${tinycc.libs}/lib" \
    mkbuiltins
  cd builtins
  make \
    CC="tcc -B ${tinycc.libs}/lib" \
    libbuiltins.a
  cd ..
  make CC="tcc -B ${tinycc.libs}/lib"

  # Install
  install -D bash ''${out}/bin/bash
  ln -s bash ''${out}/bin/sh
''
